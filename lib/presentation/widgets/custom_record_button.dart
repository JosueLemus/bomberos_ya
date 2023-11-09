import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

class CustomRecordButton extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  const CustomRecordButton({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 5, color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
