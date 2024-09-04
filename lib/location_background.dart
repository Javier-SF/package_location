import 'package:flutter/material.dart';
import 'package:location/location.dart';

class MyLocationBackground extends StatefulWidget {
  const MyLocationBackground({super.key});

  @override
  State<MyLocationBackground> createState() => _MyLocationBackgroundState();
}

class _MyLocationBackgroundState extends State<MyLocationBackground> {
  bool _isTracking = false;
  bool _serviceEnabled = false;
  Location location = Location();
  late LocationData _locationData;
  PermissionStatus _permissionGranted = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _initializeLocation();

  }
  Future<void> _initializeLocation() async{
    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }
   //config para que funcione en segundo plano
    location.enableBackgroundMode(enable: true);
    _starTracking();
  }

  void _starTracking() {
    if(_isTracking) return;

    _isTracking = true;
    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationData = currentLocation;
      print('${currentLocation.longitude} ${currentLocation.longitude}');
    });
  }

  @override
  void dispose() {
    // Deshabilitar el modo de segundo plano si es necesario
    location.enableBackgroundMode(enable: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(child: _isTracking ? const Text('Rastreando ubicacion en segundo plano') : const Text('Inicializando'),),
    );
  }
}
