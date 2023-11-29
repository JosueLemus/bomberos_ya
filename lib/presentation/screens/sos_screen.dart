import 'package:animate_do/animate_do.dart';
import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 32),
        child: Column(
          children: [
            const Text('¿Estas en una emergencia ?',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText)),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Presiona el botón de abajo para contactarte con los bomberos',
              style: TextStyle(fontSize: 16, color: AppColors.secondaryText),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: FadeIn(
                  duration: const Duration(seconds: 2),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(150),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.primaryColor,
                            blurRadius: 30,
                          )
                        ]),
                    child: const Center(
                        child: Text(
                      'SOS',
                      style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                  )),
            ),
            FadeInRight(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 4))
                    ]),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            "https://i.pinimg.com/originals/37/8a/27/378a270e775265622393da8c0527417e.jpg",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Tu direccion actual",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Av. Banzer 1234, Equipetrol, Santa Cruz. ",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
