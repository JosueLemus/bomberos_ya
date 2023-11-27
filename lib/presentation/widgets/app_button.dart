import 'package:bomberos_ya/config/theme/app_colors.dart';
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
      child: InkWell(
        onTap: onPressed,
        child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: onPressed == null ? Colors.grey : AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: onPressed == null
                    ? []
                    : const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(0, 3))
                      ]),
            width: double.infinity,
            child: Center(
                child: Text(text, style: TextStyles.filledButtonTextStyle))),
      ),
    );
  }
}
