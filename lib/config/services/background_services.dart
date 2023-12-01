import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bomberos_ya/config/helpers/db_helper.dart';
import 'package:bomberos_ya/config/services/api_services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 20), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.
        flutterLocalNotificationsPlugin.show(
          888,
          'COOL SERVICE',
          'Awesome ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
        final connectivityResult = await (Connectivity().checkConnectivity());

        final String x = connectivityResult == ConnectivityResult.ethernet ||
                connectivityResult == ConnectivityResult.mobile ||
                connectivityResult == ConnectivityResult.wifi
            ? "CONECTADO"
            : "NO CONECTADO";

        if (x == "CONECTADO") {
          // Obtener el elemento mas antiguo de la lista de eventos
          // Si no tiene hash, hacer el primer request para obtener hash
          // Si ya tiene el hash mandar por partes
          // En cada envio de partes ir incrementando las partes en uno

          // Si es la ultima parte, llamar al servicio de JOIN
          final report = await ReportRequestDataBase.instance.getOldestReport();
          final apiServices = ApiServices();
          // Si no hay reportes para el servicio
          if (report == null) {
            print("BACKGROUND=======>" + "pARANDO SERVICIO");
            service.invoke("stopService");
          } else {
            final hash = report.hash;
            // Si no tiene hash, hacer el primer request para obtener hash
            if (hash.isEmpty) {
              final apiHash = await apiServices.postReport(report);
              report.hash = apiHash;
              print("BACKGROUND=======>" + "PEDIR HASH");
              ReportRequestDataBase.instance.updateReport(report);
            }
            // Si ya tiene el hash mandar por partes
            else {
              try {
                final success = await apiServices.fileParts(report);
                if (success) {
                  print("SI SE PUDO BURRO");
                  int reportPart = int.parse(report.part);
// Si es la ultima parte, llamar al servicio de JOIN y borrar el request
                  print("BACKGROUND=======>" +
                      "REPORT PART" +
                      reportPart.toString());

                  if (reportPart >= 5) {
                    ReportRequestDataBase.instance.deleteReport(report.id);
                    service.setForegroundNotificationInfo(
                      title: "UNIENDO TODO",
                      content: "Parte $reportPart",
                    );
                    await apiServices.joinFileParts(hash);

                    print("REPORTE ELIMINADO !!!!!!!!!!!!!!!!!!!!");
                    service.setForegroundNotificationInfo(
                      title: "eliminando reporte",
                      content: "Parte $reportPart",
                    );
                  } else {
                    service.setForegroundNotificationInfo(
                      title: "SUBIENDO PARTES DE REPORTE",
                      content: "Parte $reportPart",
                    );
                    print("BACKGROUND=======>" + "AUMENTANDO PARTES");
                    // Caso contrario incrementar las partes
                    reportPart++;
                    report.part = reportPart.toString();
                    ReportRequestDataBase.instance.updateReport(report);
                  }
                } else {
                  print("NARANJAS");
                }
              } catch (e) {
                print(e.toString());
              }
            }
          }

          // await Firebase.initializeApp(); // Inicializa Firebase

          // final DatabaseReference _databaseReference =
          //     FirebaseDatabase.instance.reference().child('items');

          // DateTime now = DateTime.now();
          // String fecha =
          //     '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}.${now.millisecond}';

          // await _databaseReference.push().set({'fecha': fecha});
        } else {
          // if you don't using custom notification, uncomment this
          service.setForegroundNotificationInfo(
            title: "My App Service",
            content: "No tienes conexion, reintentando.....",
          );
        }
      }
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}
