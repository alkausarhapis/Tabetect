import 'package:flutter/material.dart';
import 'package:tabetect/styles/colors/app_color.dart';
import 'package:tabetect/styles/typography/app_text_style.dart';

class AppTheme {
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: AppTextStyle.displayLarge,
      displayMedium: AppTextStyle.displayMedium,
      displaySmall: AppTextStyle.displaySmall,
      headlineLarge: AppTextStyle.headlineLarge,
      headlineMedium: AppTextStyle.headlineMedium,
      headlineSmall: AppTextStyle.headlineSmall,
      titleLarge: AppTextStyle.titleLarge,
      titleMedium: AppTextStyle.titleMedium,
      titleSmall: AppTextStyle.titleSmall,
      bodyLarge: AppTextStyle.bodyLargeBold,
      bodyMedium: AppTextStyle.bodyLargeMedium,
      bodySmall: AppTextStyle.bodyLargeRegular,
      labelLarge: AppTextStyle.labelLarge,
      labelMedium: AppTextStyle.labelMedium,
      labelSmall: AppTextStyle.labelSmall,
    );
  }

  static ColorScheme get _lightColorScheme {
    return ColorScheme.fromSeed(
      seedColor: AppColor.primaryRed.color,
      brightness: Brightness.light,
      primary: AppColor.primaryRed.color,
      secondary: AppColor.darkBlue.color,
      surface: AppColor.brokenWhite.color,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColor.darkBlue.color,
    );
  }

  static ColorScheme get _darkColorScheme {
    return ColorScheme.fromSeed(
      seedColor: AppColor.primaryRed.color,
      brightness: Brightness.dark,
      primary: AppColor.primaryRed.color,
      secondary: AppColor.brokenWhite.color,
      surface: AppColor.darkBlue.color,
      onPrimary: Colors.white,
      onSecondary: AppColor.darkBlue.color,
      onSurface: AppColor.brokenWhite.color,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: _lightColorScheme,
      textTheme: textTheme,
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColor.brokenWhite.color,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.brokenWhite.color,
        foregroundColor: AppColor.darkBlue.color,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryRed.color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: _darkColorScheme,
      textTheme: textTheme,
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColor.darkBlue.color,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.darkBlue.color,
        foregroundColor: AppColor.brokenWhite.color,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryRed.color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
