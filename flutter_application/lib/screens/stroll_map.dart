import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/provider/location_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StrollMap extends StatelessWidget {
  const StrollMap({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
          child: GoogleMapsPage(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GoogleMapsPage(),
      ),
    );
  }
}

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({Key? key}) : super(key: key);
  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBarHeder(), body: googleMapUI());
  }
}

Widget googleMapUI() {
  return Consumer<LocationProvider>(
    builder: (consumerContext, model, child) {
      if (model.locationPosition != null) {
        return Column(
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: model.locationPosition,
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (GoogleMapController controller) {},
              ),
            )
          ],
        );
      }

      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}
