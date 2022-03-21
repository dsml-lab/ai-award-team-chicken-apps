import json
import googlemaps
import pandas as pd
import firebase_admin
from tqdm import tqdm
from firebase_admin import firestore
from firebase_admin import credentials
from auth.apikey import placeAPI


def main():
    # データの読み込み
    df = pd.read_csv("./data/mapPlaceID.csv", encoding="utf-8-sig")
    opendata = pd.read_csv("./data/dataset.csv", encoding="utf-8-sig")
    # インスタンスを生成
    client = googlemaps.Client(placeAPI)
    # firebaseの初期化
    firebaseInitialize()
    # Firestore アクセス
    db = firestore.client()
    data = {}
    for i in tqdm(df.index, total=len(df)):
        spot = client.place(place_id=df.loc[i, "PlaceID"], language="ja")["result"]
        # spot = load_json_file(path="./data/place/{}.json".format(df.loc[i, "PlaceID"]))["result"]
        # 画像のURLを取得
        if "photos" not in spot.keys():
            continue
        data["image"] = get_images(photos=spot["photos"])
        # レビュ情報を取得
        if "reviews" not in spot.keys():
            continue
        data["reviews"] = get_reviews(reviews=spot["reviews"])
        # 緯度経度を取得
        data["lat"] = float(spot["geometry"]["location"]["lat"])
        data["lng"] = float(spot["geometry"]["location"]["lng"])
        # 概要情報を取得
        data["outline"] = opendata.loc[opendata["GoogleMAP"] == df.loc[i, "GoogleMAP"], "概要"].values[0]
        # 区分情報を取得
        data["types"] = opendata.loc[opendata["GoogleMAP"] == df.loc[i, "GoogleMAP"], "区分"].values[0]
        # 名前情報を取得
        data["name"] = spot["name"]
        db.collection("spots").document(spot["name"]).set(data)
        # break


def firebaseInitialize():
    if (not firebase_admin._apps):
        cred = credentials.Certificate("./auth/ai-award-team-chicken-firebase-adminsdk.json")  # 秘密鍵
        firebase_admin.initialize_app(cred)


def get_images(photos: dict):
    output = {}
    length = min(len(photos), 4)
    for i in range(0, length, 1):
        output[str(i)] = {}
        # 写真を撮影したユーザ名を取得
        output[str(i)]["user"] = photos[i]["html_attributions"][0].split(">")[-2].split("<")[0]
        # 写真のURLを取得
        url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth={width}&maxheight={height}&photoreference={photo_reference}&key=".format(width=photos[i]["width"], height=photos[i]["height"], photo_reference=photos[i]["photo_reference"])
        output[str(i)]["photo"] = url
    return output


def get_reviews(reviews: dict):
    output = {}
    length = min(len(reviews), 4)
    for i in range(0, length, 1):
        output[str(i)] = {}
        output[str(i)]["user"] = reviews[i]["author_name"]
        output[str(i)]["photo"] = reviews[i]["profile_photo_url"]
        output[str(i)]["text"] = reviews[i]["text"].replace('\n', '')
        output[str(i)]["time"] = reviews[i]["relative_time_description"]
    return output


def create_mapPlaceID():
    df = pd.read_csv("./data/dataset.csv", encoding="utf-8-sig")
    # インスタンスを生成
    client = googlemaps.Client(placeAPI)
    data = []
    for i in df.index:
        place = df.loc[i, "GoogleMAP"]
        result = client.geocode(place)
        if len(result) != 0:
            data.append([place, result[0]["place_id"]])
    df = pd.DataFrame(data, columns=["GoogleMAP", "PlaceID"])
    df.to_csv("./data/mapPlaceID.csv", encoding="utf-8-sig", index=False)


def load_json_file(path: str):
    with open(path, 'r', encoding="utf-8-sig") as fp:
        data = json.load(fp)
    return data


def save_json_file(path: str, data: dict):
    with open(path, 'w', encoding="utf-8-sig") as fp:
        json.dump(data, fp)


if __name__ == "__main__":
    main()