import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // 位置取得のプラグイン
import 'package:google_fonts/google_fonts.dart'; // フォントススタイルのプラグイン
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Mapのプラグイン

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        textTheme:
            GoogleFonts.notoSansJavaneseTextTheme(Theme.of(context).textTheme),
      ),
      home: MyHomePage(title: 'Flutter Google Maps Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    LatLng _position = await getLocation();
    print(
        "緯度:${_position.latitude.toStringAsExponential(2)} 経度:${_position.longitude.toStringAsExponential(2)}");
    CameraPosition _kLake = CameraPosition(
      target: _position,
      bearing: 192.8334901395799,
      zoom: 19.151926040649414,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  // 現在の位置を取得する関数(
  Future<LatLng> getLocation() async {
    // 現在の位置を取得
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high, //位置データの精度
      forceAndroidLocationManager: true, // エミュレーターの管理権限
    );
    return LatLng(position.latitude, position.longitude);
  }
}
