import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  Position currentLocation;
  LatLng _center;

  Set<Marker> _markers = {};

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<Position> locateUser() async {
    return getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      _markers.add(Marker(
          markerId: MarkerId("home"),
          position: _center,
          infoWindow: InfoWindow(title: "Home!")));
    });
    print('center $_center');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _center == null
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    markers: _markers,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                  ),
                  Positioned(
                    top: 40.0,
                    left: 10.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          iconSize: 20,
                          icon: Icon(Icons.arrow_back, ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
