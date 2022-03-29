import json
import numpy as np
import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
from geopy.distance import great_circle


def stroll_function(request):
    # Firebaseの初期化
    firebase_initialize()
    # Firestoreにアクセス
    db = firestore.client()
    # リクエストを受け取る
    request_json = request.get_json()
    latitude = request_json['latitude']  # 緯度
    longitude = request_json['longitude']  # 経度
    origin = "{},{}".format(latitude, longitude)  # 現在地のGPS座標
    # FireStoreのDocument(スポット情報)を取得
    db_spots = db.collection('spots')
    # 現在地から近い3つの場所をスポットを決定する
    result = decision_close_spots(db=db_spots, origin=origin)
    # Jsonで返却
    print(result)
    result = json.dumps(result, ensure_ascii=False)
    return result

# {'0': {'name': '寒梅酒造(株)', 'lat': 36.0650049, 'lng': 139.6754501}, '1': {'name': 'Bal style えんの蔵 久喜店', 'lat': 36.0673919, 'lng': 139.6754259}, '2': {'name': 'パティスリー・アソルティ', 'lat': 36.0647783, 'lng': 139.6804034}}


def decision_close_spots(db: object, origin: str):
    # 現在地->スポットまでの距離を計算して距離が小さい順に並び替え
    dist_spots = []
    doc = db.get()
    for spot in doc:
        info = spot.to_dict()
        dist_spots.append(great_circle(origin.split(","), (info["lat"], info["lng"])).m)
    doc = np.array(doc)[np.argsort(dist_spots)]
    # 近い3スポットを返却
    result = {}
    for i in range(3):
        info = doc[i].to_dict()
        # 結果を格納
        result[str(i)] = {}
        result[str(i)]["name"] = info["name"]
        result[str(i)]["lat"] = info["lat"]
        result[str(i)]["lng"] = info["lng"]
    return result


# Firebaseの初期化
def firebase_initialize():
    if (not firebase_admin._apps):
        cred = credentials.Certificate("./auth/ai-award-team-chicken-firebase-adminsdk.json")  # 秘密鍵
        firebase_admin.initialize_app(cred)