[![アプリタイトル](./image/アプリロゴ.png)](https://youtu.be/KuQwmeWf6hQ)

``画像をクリックするとアプリの説明(youtube)を聞くことができます``

## 「**みりょくどおり**」とは？？

>日々の日常で気になるけど通り過ぎているお店はありませんか？
>お散歩したいけど目的地がなく心が折れていませんか？
>在宅勤務になって地元に興味持ち始めていませんか？

そんな時にぜひおすすめしたいアプリが「**みりょくどおり**」です！！
あなたの望み""どおり""のスポットをたくさん見つけてあなたの""魅力通り(どおり)""を開拓してください！

スマホのGPS情報をもとに現在地から最も近い「**隠れた魅力**」をお知らせします。自治体が提供しているオープンデータをもとに地元の観光地や飲食店、景観情報をまとめているため地元に特化した情報を得ることができます。※1


Googleアカウントでログインできるためユーザ登録が不要です。クロスプラットフォーム開発フレームワークとして「**Flutter**」を採用しているため、Androidとios、Webアプリに対応可能です。※2

観光地や飲食店など実際に足を運んだ方々のコメントを「**声レビュー**」として聞くことができ、より親近感を得ることができます。※3

```
※1：現在(2022/03/21時点)は久喜市を対象に3つのジャンル(観光地・飲食店・景観)から78店舗の情報が登録されています。
※2：Android向けに対応しており、Google Pixel3a(エミュレータ)とAQUOS zero2(実機)で動作確認済み
※3：デモ版ではGoogleが提供しているPlaceAPIから登録店舗のレビュー情報を取得しFlutterのプラグイン(flutter_tts)を用いて音声化しています。
```

<img src="/image/タイトル画面.png" width="150px"> <img src="/image/モード選択画面.png" width="150px"> <img src="/image/レビュ画面.png" width="150px">

### **みりょくどおり**が持つ2つのモード

#### 1. お散歩モード

このモードは普段の歩いている道にある魅力を見つけたい人におすすめです。目的地を設定しないことで、自由気ままに散策することが可能となります。``※実装予定``

#### 2. 推薦モード

このモードは目的地を決めて欲しい人や普段とは違う道で知らない隠れた魅力を見つけたい人におすすめです。1.目的地までの時間,2.寄り道にかけても良い時間,3.ジャンルから目的地と隠れた魅力スポットをあなたに推します。``※実装済``

<img src="/image/推薦モードの入力画面.png" width="150px"> <img src="/image/推薦モードのマップ画面.png" width="150px">

``※目的地：赤いピン画像 / 道中の隠れた魅力スポット：緑円マーク / 現在地：青点``

### **みりょくどおり**が伝える"**みりょく**"

みりょくどおりは 1.スポットの紹介文, 2.スポットのレビュー, 3.補足情報を伝えます。スポットの紹介文ではお店の情報と写真で紹介します。スポットのレビューは音声で伝えるため、イヤホンを通して聞くことができます。補足情報はお店の限定商品やイベント情報、店長からのおすすめなどを紹介します。

``
デモ実装では、スポットの紹介文を自治体が提供しているオープンデータから取得しており、魅力溢れた文章になっています。スポットのレビューはGoogleMapのレビュー情報を取得しています。補足情報と写真の添付は実装予定となります。
``

## **みりょくどおり**を支える技術

1. このアプリはクロスプラットフォーム開発フレームワークとして「**Flutter**」を用いて開発しています。使用したパッケージを下記に示します。

   - GPS座標を取得するためのパッケージ([location:4.3.0](https://pub.dev/packages/location))

   - レビュ情報の音声合成を行うパッケージ([flutter_tts:3.3.3](https://pub.dev/packages/flutter_tts))

   - Googleフォントを利用するためのパッケージ([google_fonts: 2.3.1](https://pub.dev/packages/google_fonts))

   - AdobeXDからFlutterへの変換を行うパッケージ([adobe_xd: 2.0.1](https://pub.dev/packages/adobe_xd))

   - 距離計算を行うためのパッケージ([geolocator: 8.2.0](https://pub.dev/packages/geolocator))

   - http通信を行うためのパッケージ※別途実装したAPIにリクエストを送るため([http: 0.13.4](https://pub.dev/packages/http))

   - ローカルにデータを保存するために使用するパッケージ([shared_preferences: 2.0.13](https://pub.dev/packages/shared_preferences))

   - GoogleMapを表示するためのFlutter plugin([google_maps_flutter: 2.1.2](https://pub.dev/packages/google_maps_flutter))

2. Googleが提供しているモバイル プラットフォーム「**Firebase**」を利用してデータベースの作成やログイン認証を行なっています。

   - Firebase Core APIを使うためのFlutter Plugin([firebase_core: 1.13.1](https://pub.dev/packages/firebase_core))

   - Firebase Authentication API を使うためのFlutter plugin([firebase_auth: 3.3.11](https://pub.dev/packages/firebase_auth))

   - Google Sign Inを使うためのFlutter plugin([google_sign_in: 5.2.4](https://pub.dev/packages/google_sign_in))

   - Cloud Firestore APIを使うためのFlutter plugin([cloud_firestore: 3.1.10](https://pub.dev/packages/cloud_firestore))

3. 実装に伴いGoogle Cloud Platform APIを使っています。(Distance Matrix API, Geocoding API, Maps SDK for Android, Places API)

4. 推薦モードにおける目的地や隠れたスポットの決定を行うためにAPIをFlaskで開発しています。

### 開発環境

- macOS Big Sur バージョン11.6（MacBook Pro）, メモリ 16 GB 3733 MHz LPDDR4X, 2 GHz クアッドコアIntel Core i5
- Android Studio Bumblebee | 2021.1.1 Patch 2
- Vscode バージョン: 1.65.2
- Flutter 2.10.3
- Python 3.8

### 開発者のコメント

Flutterを始めて使用しました。普段使っているPythonとは異なる部分が多く、モバイルアプリケーションの開発も初めての為に慣れないことが多く難しかったです。UIはAdobeXDを用いることで必要な工数を減らすことができました。
