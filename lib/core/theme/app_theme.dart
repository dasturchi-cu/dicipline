import 'package:flutter/material.dart';

import 'app_colors.dart';

import 'app_typography.dart';



class AppTheme {

  AppTheme._();



  static ThemeData light() => _buildTheme(Brightness.light);



  static ThemeData dark() => _buildTheme(Brightness.dark);



  static ThemeData _buildTheme(Brightness brightness) {

    final isLight = brightness == Brightness.light;

    final background =

        isLight ? AppColors.lightBackground : AppColors.darkBackground;

    final surface = isLight ? AppColors.lightSurface : AppColors.darkSurface;

    final border = isLight ? AppColors.lightBorder : AppColors.darkBorder;

    final textPrimary =

        isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary;



    return ThemeData(

      useMaterial3: true,

      brightness: brightness,

      fontFamily: AppTypography.fontFamily,

      colorScheme: ColorScheme(

        brightness: brightness,

        primary: AppColors.primary,

        onPrimary: Colors.white,

        secondary: AppColors.secondary,

        onSecondary: Colors.white,

        error: AppColors.error,

        onError: Colors.white,

        surface: surface,

        onSurface: textPrimary,

      ),

      scaffoldBackgroundColor: background,

      textTheme: AppTypography.textTheme(brightness),

      appBarTheme: AppBarTheme(

        elevation: 0,

        scrolledUnderElevation: 0,

        centerTitle: false,

        backgroundColor: background,

        foregroundColor: textPrimary,

        titleTextStyle: AppTypography.textTheme(brightness).titleLarge,

      ),

      cardTheme: CardThemeData(

        elevation: 0,

        color: surface,

        surfaceTintColor: Colors.transparent,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(AppRadius.lg),

          side: BorderSide(color: border),

        ),

      ),

      navigationBarTheme: NavigationBarThemeData(

        elevation: 0,

        height: 72,

        backgroundColor: isLight ? AppColors.glassLight : AppColors.glassDark,

        indicatorColor: AppColors.navIndicator,

        labelTextStyle: WidgetStateProperty.resolveWith((states) {

          final selected = states.contains(WidgetState.selected);

          return TextStyle(

            fontSize: 11,

            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,

            color: selected ? AppColors.primary : AppColors.lightTextSecondary,

          );

        }),

      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(

        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,

        elevation: 4,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),

        ),

      ),

      inputDecorationTheme: InputDecorationTheme(

        filled: true,

        fillColor: surface,

        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(AppRadius.md),

          borderSide: BorderSide(color: border),

        ),

        enabledBorder: OutlineInputBorder(

          borderRadius: BorderRadius.circular(AppRadius.md),

          borderSide: BorderSide(color: border),

        ),

        focusedBorder: OutlineInputBorder(

          borderRadius: BorderRadius.circular(AppRadius.md),

          borderSide: const BorderSide(color: AppColors.primary, width: 2),

        ),

        contentPadding: const EdgeInsets.symmetric(

          horizontal: AppSpacing.md,

          vertical: AppSpacing.sm + 4,

        ),

      ),

      dividerTheme: DividerThemeData(color: border),

      snackBarTheme: SnackBarThemeData(

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(AppRadius.md),

        ),

      ),

      pageTransitionsTheme: const PageTransitionsTheme(

        builders: {

          TargetPlatform.android: CupertinoPageTransitionsBuilder(),

          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),

        },

      ),

    );

  }

}

