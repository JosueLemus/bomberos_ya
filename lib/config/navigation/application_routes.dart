import 'package:flutter/material.dart';
import '../../presentation/screens/screens.dart';

class Routes {
  static String home = 'home';
  static String reportIncident = 'reportIncident';
}

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => const SplashScreen(),
    Routes.home: (BuildContext context) => const HomeScreen(),
    Routes.reportIncident: (BuildContext context) => const SimpleReportScreen(),
  };
}
