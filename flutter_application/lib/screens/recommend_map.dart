import 'package:flutter/material.dart';
import 'package:flutter_application/screens/stroll_map.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/provider/location_provider.dart';

class RecommendMap extends StatelessWidget {
  const RecommendMap({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
          child: const GoogleMapsPage(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GoogleMapsPage(),
      ),
    );
  }
}
