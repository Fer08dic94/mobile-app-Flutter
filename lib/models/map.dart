import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  String address = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      body: OpenStreetMapSearchAndPick(
          center: LatLong(20.5931, -100.392),
          buttonColor: Colors.blue,
          buttonText: 'Establece una direccion',
          onPicked: (pickedData) {
            print(pickedData.latLong.latitude);
            print(pickedData.latLong.longitude);
            print(pickedData.address);
          }),
    );
  }
}
