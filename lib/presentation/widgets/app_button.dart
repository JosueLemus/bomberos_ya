import 'package:bomberos_ya/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final EdgeInsetsGeometry padding;
  const AppButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: onPressed == null
              ? ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  backgroundColor: Colors.grey,
                  textStyle: const TextStyle(color: Colors.white))
              : null,
          child: Text(text, style: TextStyles.filledButtonTextStyle),
        ),
      ),
    );
  }
}
