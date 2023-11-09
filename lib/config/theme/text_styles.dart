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

  static const TextStyle regularSecondaryMediumTextStyle = TextStyle(
    color: AppColors.secondaryText,
    fontSize: 16
  );

  static const TextStyle regularSecondarySmallTextStyle = TextStyle(
    color: AppColors.secondaryText,
    fontSize: 14
  );

  static const TextStyle filledButtonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold
  );

  static const TextStyle textButtonTextStyle = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 16,
    fontWeight: FontWeight.bold
  );

  
}