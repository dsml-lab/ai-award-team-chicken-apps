import sys
import json
import random
import requests
import itertools
import  numpy as np
import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
from geopy.distance import great_circle
sys.path.append("./")
from auth.apikey import distanceAPI


def recommend_function(request):
    # Firebaseの初期化
    firebase_initialize()
    # Firestoreにアクセス
    db = firestore.client()
    # リクエストを受け取る
    request_json = request.get_json()
    user = request_json['user']  # ユーザ名
    latitude = request_json['latitude']  # 緯度
    longitude = request_json['longitude']  # 経度
    origin = "{},{}".format(latitude, longitude)  # 現在地のGPS座標
    # FireStoreのDocument(ユーザ選択情報)を取得
    db_recommend = db.collection('recommend').document(user).get().to_dict()
    genre = db_recommend["genre"]  # 目的地のジャンル(True,False)
    place_time = db_recommend["place_time"]  # 目的地までの時間(分)
    # FireStoreのDocument(スポット情報)を取得
    db_spots = db.collection('spots')
    # 目的地を決定
    destination = decision_destination(db=db_spots, origin=origin, genre=genre, place_time=place_time)
    # 現在地から目的地までの道中のスポットを決定する
    total_time = (db_recommend["detour_time"]+db_recommend["place_time"])*60  # 目的地までの時間 + 寄り道時間
    result = decision_spots(destination=destination, db=db_spots, origin=origin, total_time=total_time)
    # Jsonで返却
    print(result)
    result = json.dumps(result, ensure_ascii=False)
    return result


def decision_destination(db: object, origin: str, genre: dict, place_time: int):
    # 指定されたジャンルのスポットだけを抽出
    doc = list(itertools.chain.from_iterable([db.where('types', '==', k).get() for k, v in genre.items() if v]))
    # 現在地->スポットまでの距離を計算して距離が小さい順に並び替え
    dist_spots = []
    for spot in doc:
        info = spot.to_dict()
        dist_spots.append(great_circle(origin.split(","), (info["lat"], info["lng"])).m)
    doc = np.array(doc)[np.argsort(dist_spots)]
    # 現在地->スポットの時間を計算
    sec_spots = []
    candidate_spots = []
    for spot in doc:
        info = spot.to_dict()
        sec = google_place_distance(origin=origin, destination="{},{}".format(info["lat"], info["lng"]))
        sec_spots.append(sec)
        candidate_spots.append(spot)
        # スポットまでの時間が指定された時間より長かったらブレイク
        if (sec > place_time*60):
            break
    # 指定された目的地までの時間内のスポットを取得(存在しない場合は最短のスポットを返却)
    sec_flag = [True if i <= place_time*60 else False for i in sec_spots]
    if sum(sec_flag) != 0:
        candidate_spots = np.array(candidate_spots)[sec_flag]
    else:
        candidate_spots = [np.array(candidate_spots)[np.argmin(sec_spots)]]
    # 候補内のスポットから目的地をランダムに取得
    random.seed(111)
    destination = random.choice(list(candidate_spots))
    return destination.to_dict()


# distanceMatrixAPIを制御する関数
def google_place_distance(origin: str, destination: list):
    api = 'https://maps.googleapis.com/maps/api/distancematrix/json'
    # print(destinations)
    params = {
            'key': distanceAPI,
            'mode': "WALKING",
            'departure_time': 'now',
            'origins': origin,
            'destinations': destination,
            'language': 'ja'
    }
    # Google Map APIにリクエスト
    raw_response = requests.get(api, params)
    parsed_response = json.loads(raw_response.text)
    sec = parsed_response["rows"][0]["elements"][0]["duration"]["value"]  # かかる時間(秒)を取得
    return sec


def decision_spots(destination: dict, db: object, origin: str, total_time: int):
    # 現在地->スポット間の距離を計算
    dist_spots = []
    spots = db.get()
    for spot in spots:
        info = spot.to_dict()
        dist_spots.append(great_circle(origin.split(","), (info["lat"], info["lng"])).m)
    # 現在地->目的地の距離を計算
    gole_point = "{},{}".format(destination["lat"], destination["lng"])
    dist_dest = great_circle(origin.split(","), gole_point.split(",")).m
    # 距離(現在地->目的地) > 距離(現在地->スポット間)となるスポットだけを抽出
    index = [True if dist_dest > i else False for i in dist_spots]
    candidate_spots = np.array(spots)[index]
    candidate_dist = np.array(dist_spots)[index]
    # 候補のスポットに対して距離が小さい順に並べる
    candidate_spots = candidate_spots[np.argsort(candidate_dist)]
    # 距離が小さい順に現在地->スポット->目的地までの時間を計算
    start_point = origin  # 出発点
    progress_time = 0  # 経過時間
    result = {}
    for i, spot in enumerate(candidate_spots):
        info = spot.to_dict()
        check_point = "{},{}".format(info["lat"], info["lng"])  # 中間点
        start2check_time = google_place_distance(origin=start_point, destination=check_point)  # 出発点->中間点
        check2gole_time = google_place_distance(origin=check_point, destination=gole_point)  # 中間点->目的地
        progress_time = progress_time + start2check_time + check2gole_time
        # 結果を格納
        result[str(i)] = {}
        result[str(i)]["name"] = info["name"]
        result[str(i)]["lat"] = info["lat"]
        result[str(i)]["lng"] = info["lng"]
        result["time"] = progress_time
        # 経過時間が指定された合計時間を超えたときにブレイク
        if progress_time > total_time:
            # 「合計時間を経過時間が超えた時の差分」が「合計時間を経過時間が超える前の差分」より大きいときに削除
            before_progress = progress_time - start2check_time - check2gole_time
            if abs(progress_time - total_time) > abs(before_progress - total_time):
                del result[str(i)]
                result["time"] = before_progress
            break
    # 目的地の結果を格納
    length = len(result)
    result[str(length-1)] = {}
    result[str(length-1)]["name"] = destination["name"]
    result[str(length-1)]["lat"] = destination["lat"]
    result[str(length-1)]["lng"] = destination["lng"]
    return result


# Firebaseの初期化
def firebase_initialize():
    if (not firebase_admin._apps):
        cred = credentials.Certificate("./auth/ai-award-team-chicken-firebase-adminsdk.json")  # 秘密鍵
        firebase_admin.initialize_app(cred)
