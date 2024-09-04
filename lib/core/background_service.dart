import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location/location.dart';

void onStart(ServiceInstance service) async {
  Location location = Location();

  // Configura el servicio para ejecutarse como un servicio en primer plano
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.setForegroundNotificationInfo(
      title: "Your App",
      content: "Tracking your location",
    );
  }

  // Configuración del seguimiento de la ubicación en segundo plano
  location.onLocationChanged.listen((LocationData currentLocation) {
    print('Ubicación en segundo plano: ${currentLocation.latitude}, ${currentLocation.longitude}');

    // Aquí puedes enviar la ubicación a un servidor, almacenarla en una base de datos, etc.
    service.invoke(
      'update',
      {
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
      },
    );
    print('Ubicación en segundo plano: ${currentLocation.latitude}, ${currentLocation.longitude}');

  });

}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Rastreando ubicación',
      initialNotificationContent: 'La aplicación está rastreando tu ubicación en segundo plano.',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      autoStart: true,
    ),
  );
  service.startService();
}

