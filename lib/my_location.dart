import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Location location = Location();
  LocationData? _locationData;
  late StreamSubscription<LocationData> _locationSubscription;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndGetLocation();
  }

  Future<void> _checkPermissionAndGetLocation() async {
    // Verificar y solicitar permisos
    final permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      try {
        // Obtener ubicación en tiempo real
        _locationSubscription =
            location.onLocationChanged.listen((LocationData currentLocation) {
          setState(() {
            _locationData = currentLocation;
          });
          print(
              'Ubicación actual: ${currentLocation.latitude}, ${currentLocation.longitude}');
        });
      } catch (e) {
        print('Error al obtener ubicación: $e');
      }
    } else {
      print('Permiso de ubicación no concedido.');
    }
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicación en Tiempo Real'),
      ),
      body: Center(
        child: _locationData == null
            ? Text('Esperando ubicación...')
            : Text(
                'Latitud: ${_locationData!.latitude}\nLongitud: ${_locationData!.longitude}',
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
