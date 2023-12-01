import 'package:bomberos_ya/config/navigation/application_routes.dart';
import 'package:bomberos_ya/config/services/background_services.dart';
import 'package:bomberos_ya/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/theme/light_theme.dart';
import 'presentation/screens/screens.dart';

void main() async {
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await Firebase.initializeApp(
      name: "denuncity-notifications",
      options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      theme: AppTheme.lightTheme,
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: ((context) => const SplashScreen()));
      },
    );
  }
}
