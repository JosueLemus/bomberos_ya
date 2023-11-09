import 'package:flutter/material.dart';

import '../../../config/theme/text_styles.dart';

class AddImagesScreen extends StatelessWidget {
  const AddImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Agrega imagenes de la situacion(0 de 4)",
          style: TextStyles.boldSecondaryLargeTextStyle,
        ),
      ],
    );
  }
}