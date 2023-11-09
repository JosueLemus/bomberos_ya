import 'package:flutter/material.dart';

import 'app_colors.dart';

class TextStyles {
  static const TextStyle primaryTextStyle = TextStyle(
    color: AppColors.primaryText,
    fontSize: 16,
  );

  static const TextStyle secondaryTextStyle = TextStyle(
    color: AppColors.secondaryText,
    fontSize: 16,
  );

  static const TextStyle boldSecondaryLargeTextStyle = TextStyle(
    color: AppColors.secondaryText,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}