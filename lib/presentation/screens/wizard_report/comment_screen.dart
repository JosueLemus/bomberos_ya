import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:bomberos_ya/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: const [
              Text(
                "Agrega un comentario de la situacion.",
                style: TextStyles.boldSecondaryLargeTextStyle,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Graba un mensaje de voz para explicar tu situación actual y cualquier detalle relevante.",
                style: TextStyles.regularSecondaryMediumTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(175)),
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(175)),
                child: Center(
                  child: Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(175)),
                      child: const Icon(
                        Icons.mic,
                        size: 150,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Aceptar',
                            style: TextStyles.filledButtonTextStyle))),
                TextButton(
                  onPressed: () {},
                  child: const Text("Enviar texto",
                      style: TextStyles.textButtonTextStyle),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
