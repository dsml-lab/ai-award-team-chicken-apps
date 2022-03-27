import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/header.dart';
import 'package:flutter_application/widgets/introduction.dart';
import 'package:flutter_application/res/apikey.dart';
import 'package:flutter_application/widgets/loading_widght.dart';
import 'package:flutter_application/widgets/map_header_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// モード選択
class RecommendMap extends StatefulWidget {
  String result;
  RecommendMap(this.result, {Key? key}) : super(key: key);
  @override
  _RecommendMap createState() => _RecommendMap();
}

class _RecommendMap extends State<RecommendMap> {
  FirebaseFirestore _db = FirebaseFirestore.instance; // インスタンスの作成
  final Location _locationService = Location(); // ロケーションのインスタンス作成
  final Completer<GoogleMapController> _controller = Completer(); // コントローラー

  // String _outline = ""; // お店の概要
  // Map<String, dynamic> _image = {}; // 写真
  // Map<String, dynamic> _review = {}; // レビュー情報
  int _target = 0; // 表示するスポットのID
  int _maxDistance = 20; // 次のスポットに移る際の距離
  double? _distanceInMeters = null; // 現在地とスポットの距離
  Map<String, dynamic> _response = {}; // APIのレスポンス結果
  late StreamSubscription _locationChangedListen; // 位置情報の変化を監視
  LocationData? _currentLocation; // 現在位置
  BitmapDescriptor? pinDestinationIcon; // 目的地のマーカ
  BitmapDescriptor? pinSpotsIcon; // スポットのマーカ
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  // APIのレスポンス結果をMapで受け取る
  Future<void> string2Map() async {
    setState(() {
      _response = jsonDecode(widget.result);
    });
  }

  // 対象とする場所の更新を行う
  Future<void> updateTarget() async {
    if (!(_distanceInMeters is Null) &
        (_response.keys.length > (_target + 1)) &
        (_maxDistance > _distanceInMeters!)) {
      setState(() {
        _target += 1;
      });
    }
  }

  // 現在地の取得
  Future<void> getLocation() async {
    _currentLocation = await _locationService.getLocation();
  }

  // 現在地の監視
  Future<StreamSubscription<LocationData>> observeLocation() async {
    return _locationService.onLocationChanged
        .listen((LocationData result) async {
      updateTarget();
      setState(() {
        _currentLocation = result;
        calculationDistance();
      });
    });
  }

  // 現在地から目的地までのルートを求める
  Future<void> _getPolyLine() async {
    // 出発点
    double _originLatitude = _currentLocation!.latitude as double;
    double _originLongitude = _currentLocation!.longitude as double;
    // 到達点
    double _destLatitude;
    double _destLongitude;
    for (var i = 0; i < (_response.keys.length - 1); i++) {
      String name = _response[i.toString()]['name'];
      _destLatitude = _response[i.toString()]['lat'];
      _destLongitude = _response[i.toString()]['lng'];
      LatLng start = LatLng(_originLatitude, _originLongitude);
      LatLng finish = LatLng(_destLatitude, _destLongitude);
      PolylineId id = PolylineId(name);
      polylines[id] = await _getRoutePolyline(start, finish, id);
      _originLatitude = _destLatitude;
      _originLongitude = _destLongitude;
    }
  }

  Future<Polyline> _getRoutePolyline(
      LatLng start, LatLng finish, PolylineId id) async {
    polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];
    PointLatLng startPoint = PointLatLng(start.latitude, start.longitude);
    PointLatLng finishPoint = PointLatLng(finish.latitude, finish.longitude);
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        distanceAPI, startPoint, finishPoint,
        travelMode: TravelMode.walking);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    Polyline polyline = Polyline(
        width: 5,
        polylineId: id,
        color: Colors.lightBlue,
        points: polylineCoordinates);
    return polyline;
  }

  // 距離計算（メートル）
  Future<void> calculationDistance() async {
    // 現在地のGPS座標
    double cLat = _currentLocation!.latitude as double;
    double cLng = _currentLocation!.longitude as double;
    // ターゲットスポットのGPS座標
    double tLat = await _response[_target.toString()]["lat"];
    double tLng = await _response[_target.toString()]["lng"];
    setState(() {
      _distanceInMeters = Geolocator.distanceBetween(cLat, cLng, tLat, tLng);
    });
  }

  // FireStoreからデータを取得する
  Future<Map<String, dynamic>> get_target_spots() async {
    DocumentSnapshot doc = await _db
        .collection('spots')
        .doc(_response[_target.toString()]["name"])
        .get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return data;
  }

  // 次のスポットまでの距離を返す
  Widget view_spots_distance() {
    if (_distanceInMeters is Null) {
      return Text("~計算中~");
    } else {
      return Text(
        "次のスポットまで\n${_distanceInMeters?.toStringAsFixed(3)}m",
        style: TextStyle(
            fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.bold),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      await getLocation();
      _locationChangedListen = await observeLocation();
      await _getPolyLine();
    });
    setSpotsMapPin();
    setDestinationMapPin();
  }

  @override
  void dispose() {
    super.dispose();
    // 監視を終了
    _locationChangedListen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // APIのレスポンスをMAPに変換
    string2Map();
    // 画面のサイズを取得
    var _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const AppBarHeder(),
        // Stack(2つのContainerを重ねる)
        body: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context)
                  .size
                  .width, // or use fixed size like 200
              height: MediaQuery.of(context).size.height * 0.1,
              child: headerButton(
                context: context,
                response: _response,
                target: _target,
                view_spots_distance: view_spots_distance(),
                get_target_spots: get_target_spots(),
              ),
            ),
            Expanded(
              child: _googleMapUI(),
            ),
          ],
        ));
  }

  // GoogleMAPのWidget
  Widget _googleMapUI() {
    //  現在位置が取れるまではローディング中
    if (_currentLocation == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_response == null) {
      string2Map();
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GoogleMap(
        mapType: MapType.normal,
        polylines: Set<Polyline>.of(polylines.values),
        markers: _createMarker(),
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentLocation!.latitude as double,
              _currentLocation!.longitude as double),
          zoom: 15,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {},
      );
    }
  }

  // マーカーをカスタマイズ
  Set<Marker> _createMarker() {
    final Set<Marker> markers = {}; // スポットに対応したマーカを格納

    for (var i = 0; i < (_response.keys.length - 1); i++) {
      String name = _response[i.toString()]['name'];
      double lat = _response[i.toString()]['lat'];
      double lng = _response[i.toString()]['lng'];
      // 目的地のマーカ
      if (i == (_response.keys.length - 2)) {
        markers.add(
          Marker(
            markerId: MarkerId(name),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: "目的地「${name}」"),
            icon: (pinDestinationIcon as BitmapDescriptor),
          ),
        );
      } else {
        markers.add(
          Marker(
            markerId: MarkerId(name),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: name),
            icon: (pinSpotsIcon as BitmapDescriptor),
          ),
        );
      }
    }
    return markers;
  }

  // 目的地のマーカ
  void setDestinationMapPin() async {
    pinDestinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1), 'assets/destination_pin.png');
  }

  // スポットのマーカ
  void setSpotsMapPin() async {
    pinSpotsIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1), 'assets/destination_pin.png');
  }
}
