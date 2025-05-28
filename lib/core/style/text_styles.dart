import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // Common styles
  static TextStyle getPageTitle(bool isDarkMode) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? AppColors.darkText : AppColors.black,
    );
  }

  static const TextStyle mainPageMenuButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static const TextStyle schedulePageTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle errorText = TextStyle(
    color: Colors.red,
    fontSize: 14,
  );

  // Course selection styles
  static const TextStyle courseRegistrationTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle sectionPopupTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle sectionPopupListTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle sectionPopupListSubtitle = TextStyle(
    fontSize: 12,
  );

  static const TextStyle sectionPopupEmpty = TextStyle(
    fontSize: 14,
    fontStyle: FontStyle.italic,
  );

  static TextStyle blockTitle(bool isDarkMode) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: isDarkMode ? AppColors.darkText : AppColors.black,
    );
  }

  static TextStyle floorTitle(bool isDarkMode) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: isDarkMode ? AppColors.darkText : AppColors.black,
    );
  }

  // Login styles
  static const TextStyle loginTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle loginButtonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.loginButtonText,
  );

  // Eligible Course styles
  static const TextStyle eligibleCourseTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.black87,
  );

  static const TextStyle eligibleCourseSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.black54,
  );
}
