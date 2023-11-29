import 'package:bomberos_ya/config/navigation/application_routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const name = 'splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Routes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        // decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //         colors: [AppColors.primaryColor, AppColors.gradientColor],
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/bombero_icono.png"),
                Text("BomberosYa!",
                    style:
                        textStyles.displaySmall!.copyWith(color: Colors.white)),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
