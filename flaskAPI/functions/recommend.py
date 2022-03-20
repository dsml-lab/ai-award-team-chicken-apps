import json
import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials


def recommend_function(request):
    if (not firebase_admin._apps):
        cred = credentials.Certificate("./auth/ai-award-team-chicken-firebase-adminsdk.json")  # 秘密鍵
        firebase_admin.initialize_app(cred)
    # Firestore アクセス
    db = firestore.client()
    #
    request_json = request.get_json()
    # document指定
    doc_ref = db.collection('recommend').document(request_json['user'])
    latitude = request_json['latitude']
    longitude = request_json['longitude']
    print(latitude, longitude)
    #  データ取得
    doc = doc_ref.get()
    sample = json.dumps(doc.to_dict(), ensure_ascii=False)
    return sample


"""


curl -X POST -H "Content-Type: application/json" -d '{"user": "BNanylTccpdirtrcDrQkdolZlhx1",
"latitude":36.005765, "longitude":139.5425833 }' http://localhost:5000/recommend
"""