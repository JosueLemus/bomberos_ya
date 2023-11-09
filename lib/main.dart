import 'package:bomberos_ya/presentation/screens/wizard_report/simple_report_screen.dart';
import 'package:flutter/material.dart';
import 'config/theme/light_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SimpleReportScreen(),
      theme: AppTheme.lightTheme,
    );
  }
}