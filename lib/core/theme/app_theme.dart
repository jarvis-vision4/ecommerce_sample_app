// Design Tokens - Maps 1:1 from Pencil design system
// Generated from: /Users/user/design_project/ecommerce-design-system.pen

import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Color tokens matching Pencil design system exactly
class AppColors {
  AppColors._();

  // Brand Colors
  static const Color brandPrimaryLight = Color(0xFF1E3A5F);
  static const Color brandPrimaryDark = Color(0xFF3B82F6);
  static const Color brandPrimaryLightLight = Color(0xFFDBEAFE);
  static const Color brandPrimaryLightDark = Color(0xFF1E3A5F);
  static const Color brandSecondaryLight = Color(0xFF059669);
  static const Color brandSecondaryDark = Color(0xFF10B981);
  static const Color brandAccentLight = Color(0xFFF59E0B);
  static const Color brandAccentDark = Color(0xFFFBBF24);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color surfaceElevatedLight = Color(0xFFF9FAFB);
  static const Color surfaceElevatedDark = Color(0xFF1F2937);
  static const Color surfaceHoverLight = Color(0xFFF3F4F6);
  static const Color surfaceHoverDark = Color(0xFF374151);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);
  static const Color textTertiaryDark = Color(0xFF6B7280);
  static const Color textInverseLight = Color(0xFFFFFFFF);
  static const Color textInverseDark = Color(0xFF111827);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // Border Colors
  static const Color borderPrimaryLight = Color(0xFFE5E7EB);
  static const Color borderPrimaryDark = Color(0xFF374151);
  static const Color borderFocus = brandPrimaryLight;
  static const Color borderError = Color(0xFFEF4444);
  static const Color borderSuccess = brandSecondaryLight;

  // Semantic Colors
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color success = brandSecondaryLight;
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = brandAccentLight;
  static const Color warningLight = Color(0xFFFFFBEB);
}

/// Spacing tokens (4px base unit)
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

/// Border radius tokens
class AppRadius {
  AppRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;
}

/// Component size tokens
class AppSizes {
  AppSizes._();

  static const double xs = 24.0;
  static const double sm = 32.0;
  static const double md = 40.0;
  static const double lg = 48.0;
  static const double xl = 56.0;
  static const double xxl = 64.0;
}

/// Shadow tokens
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -4,
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 8),
      blurRadius: 10,
      spreadRadius: -6,
    ),
  ];
}

/// Typography tokens
class AppTypography {
  AppTypography._();

  static const String fontSans = 'Inter';
  static const String fontDisplay = 'Inter';
  static const String fontMono = 'JetBrains Mono';

  static const double textXs = 12.0;
  static const double textSm = 14.0;
  static const double textBase = 16.0;
  static const double textLg = 18.0;
  static const double textXl = 20.0;
  static const double text2xl = 24.0;
  static const double text3xl = 30.0;
  static const double text4xl = 36.0;
  static const double text5xl = 48.0;

  static const FontWeight fontNormal = FontWeight.w400;
  static const FontWeight fontMedium = FontWeight.w500;
  static const FontWeight fontSemibold = FontWeight.w600;
  static const FontWeight fontBold = FontWeight.w700;

  static const double leadingTight = 1.25;
  static const double leadingNormal = 1.5;
  static const double leadingRelaxed = 1.75;
}

/// Z-index tokens
class AppZIndex {
  AppZIndex._();

  static const int dropdown = 100;
  static const int sticky = 200;
  static const int fixed = 300;
  static const int modalBackdrop = 400;
  static const int modal = 500;
  static const int popover = 600;
  static const int tooltip = 700;
}

/// Breakpoint tokens
class AppBreakpoints {
  AppBreakpoints._();

  static const double sm = 640;
  static const double md = 768;
  static const double lg = 1024;
  static const double xl = 1280;
}

/// Theme data builder
class AppTheme {
  AppTheme._();

  static ThemeData light() => _buildTheme(Brightness.light);
  static ThemeData dark() => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    final ColorScheme colorScheme = ColorScheme(
      brightness: brightness,
      primary: isLight ? AppColors.brandPrimaryLight : AppColors.brandPrimaryDark,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: isLight ? AppColors.brandPrimaryLightLight : AppColors.brandPrimaryLightDark,
      onPrimaryContainer: isLight ? AppColors.brandPrimaryLight : AppColors.textOnPrimary,
      secondary: isLight ? AppColors.brandSecondaryLight : AppColors.brandSecondaryDark,
      onSecondary: AppColors.textOnSecondary,
      secondaryContainer: isLight ? AppColors.successLight : AppColors.brandSecondaryLight,
      onSecondaryContainer: isLight ? AppColors.brandSecondaryLight : AppColors.textOnSecondary,
      tertiary: isLight ? AppColors.brandAccentLight : AppColors.brandAccentDark,
      onTertiary: AppColors.textOnPrimary,
      tertiaryContainer: isLight ? AppColors.warningLight : AppColors.brandAccentLight,
      onTertiaryContainer: isLight ? AppColors.brandAccentLight : AppColors.textOnPrimary,
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.error,
      surface: isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
      onSurface: isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark,
      surfaceContainerHighest: isLight ? AppColors.surfaceHoverLight : AppColors.surfaceHoverDark,
      onSurfaceVariant: isLight ? AppColors.textSecondaryLight : AppColors.textSecondaryDark,
      outline: isLight ? AppColors.borderPrimaryLight : AppColors.borderPrimaryDark,
      outlineVariant: isLight ? AppColors.borderPrimaryLight : AppColors.borderPrimaryDark,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: isLight ? AppColors.surfaceDark : AppColors.surfaceLight,
      onInverseSurface: isLight ? AppColors.textInverseLight : AppColors.textInverseDark,
      inversePrimary: isLight ? AppColors.brandPrimaryDark : AppColors.brandPrimaryLight,
    );

    final TextTheme textTheme = TextTheme(
      displayLarge: _textStyle(57, FontWeight.w400, 64, -0.25),
      displayMedium: _textStyle(45, FontWeight.w400, 52, 0),
      displaySmall: _textStyle(36, FontWeight.w400, 44, 0),
      headlineLarge: _textStyle(32, FontWeight.w600, 40, 0),
      headlineMedium: _textStyle(28, FontWeight.w600, 36, 0),
      headlineSmall: _textStyle(24, FontWeight.w600, 32, 0),
      titleLarge: _textStyle(22, FontWeight.w500, 28, 0),
      titleMedium: _textStyle(16, FontWeight.w500, 24, 0.15),
      titleSmall: _textStyle(14, FontWeight.w500, 20, 0.1),
      bodyLarge: _textStyle(16, FontWeight.w400, 24, 0.5),
      bodyMedium: _textStyle(14, FontWeight.w400, 20, 0.25),
      bodySmall: _textStyle(12, FontWeight.w400, 16, 0.4),
      labelLarge: _textStyle(14, FontWeight.w500, 20, 0.1),
      labelMedium: _textStyle(12, FontWeight.w500, 16, 0.5),
      labelSmall: _textStyle(11, FontWeight.w500, 16, 0.5),
    ).apply(
      fontFamily: AppTypography.fontSans,
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: AppTypography.fontSans,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        toolbarHeight: AppSizes.lg,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.outlineVariant,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(AppSizes.md, AppSizes.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Filled Button Theme (Primary)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.outlineVariant,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(AppSizes.md, AppSizes.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
          side: BorderSide(
            color: colorScheme.outline,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(AppSizes.md, AppSizes.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme (Ghost)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(AppSizes.md, AppSizes.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.error,
        ),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        disabledColor: colorScheme.outlineVariant,
        selectedColor: colorScheme.primaryContainer,
        secondarySelectedColor: colorScheme.secondaryContainer,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
        brightness: brightness,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: colorScheme.primaryContainer,
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        titleTextStyle: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: textTheme.labelSmall,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),

      // Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: colorScheme.primary,
              size: 24,
            );
          }
          return IconThemeData(
            color: colorScheme.onSurfaceVariant,
            size: 24,
          );
        }),
        height: AppSizes.xl,
        surfaceTintColor: Colors.transparent,
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primaryContainer;
          }
          return Colors.transparent;
        }),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 16,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        modalBackgroundColor: colorScheme.surface,
        dragHandleColor: colorScheme.outlineVariant,
        showDragHandle: true,
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        elevation: 6,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: 24,
      ),

      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          disabledForegroundColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(
          color: colorScheme.outline,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurfaceVariant;
        }),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.outlineVariant;
        }),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.outlineVariant,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        valueIndicatorColor: colorScheme.primary,
        valueIndicatorTextStyle: textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimary,
        ),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 12,
        ),
        trackHeight: 4,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.outlineVariant,
        circularTrackColor: colorScheme.outlineVariant,
      ),

      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: textTheme.labelSmall?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        verticalOffset: 8,
      ),

      // Extensions
      extensions: [
        CustomColors(
          brandPrimary: isLight ? AppColors.brandPrimaryLight : AppColors.brandPrimaryDark,
          brandSecondary: isLight ? AppColors.brandSecondaryLight : AppColors.brandSecondaryDark,
          brandAccent: isLight ? AppColors.brandAccentLight : AppColors.brandAccentDark,
          surfaceElevated: isLight ? AppColors.surfaceElevatedLight : AppColors.surfaceElevatedDark,
          surfaceHover: isLight ? AppColors.surfaceHoverLight : AppColors.surfaceHoverDark,
          textTertiary: isLight ? AppColors.textTertiaryLight : AppColors.textTertiaryDark,
          borderFocus: AppColors.borderFocus,
          errorLight: AppColors.errorLight,
          successLight: AppColors.successLight,
          warningLight: AppColors.warningLight,
        ),
        CustomTextStyles(
          displayLarge: textTheme.displayLarge!,
          displayMedium: textTheme.displayMedium!,
          displaySmall: textTheme.displaySmall!,
          headlineLarge: textTheme.headlineLarge!,
          headlineMedium: textTheme.headlineMedium!,
          headlineSmall: textTheme.headlineSmall!,
          titleLarge: textTheme.titleLarge!,
          titleMedium: textTheme.titleMedium!,
          titleSmall: textTheme.titleSmall!,
          bodyLarge: textTheme.bodyLarge!,
          bodyMedium: textTheme.bodyMedium!,
          bodySmall: textTheme.bodySmall!,
          labelLarge: textTheme.labelLarge!,
          labelMedium: textTheme.labelMedium!,
          labelSmall: textTheme.labelSmall!,
        ),
        const CustomSpacing(
          xs: AppSpacing.xs,
          sm: AppSpacing.sm,
          md: AppSpacing.md,
          lg: AppSpacing.lg,
          xl: AppSpacing.xl,
          xxl: AppSpacing.xxl,
          xxxl: AppSpacing.xxxl,
        ),
        const CustomRadius(
          xs: AppRadius.xs,
          sm: AppRadius.sm,
          md: AppRadius.md,
          lg: AppRadius.lg,
          xl: AppRadius.xl,
          full: AppRadius.full,
        ),
       const CustomSizes(
          xs: AppSizes.xs,
          sm: AppSizes.sm,
          md: AppSizes.md,
          lg: AppSizes.lg,
          xl: AppSizes.xl,
          xxl: AppSizes.xxl,
        ),
       const CustomShadows(
          xs: AppShadows.xs,
          sm: AppShadows.sm,
          md: AppShadows.md,
          lg: AppShadows.lg,
          xl: AppShadows.xl,
        ),
      ],
    );
  }

  static TextStyle _textStyle(double fontSize, FontWeight weight, double lineHeight, double letterSpacing) {
    return TextStyle(
      fontFamily: AppTypography.fontSans,
      fontSize: fontSize,
      fontWeight: weight,
      height: lineHeight / fontSize,
      letterSpacing: letterSpacing,
    );
  }
}

// Custom Theme Extensions
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.brandPrimary,
    required this.brandSecondary,
    required this.brandAccent,
    required this.surfaceElevated,
    required this.surfaceHover,
    required this.textTertiary,
    required this.borderFocus,
    required this.errorLight,
    required this.successLight,
    required this.warningLight,
  });

  final Color brandPrimary;
  final Color brandSecondary;
  final Color brandAccent;
  final Color surfaceElevated;
  final Color surfaceHover;
  final Color textTertiary;
  final Color borderFocus;
  final Color errorLight;
  final Color successLight;
  final Color warningLight;

  @override
  CustomColors copyWith({
    Color? brandPrimary,
    Color? brandSecondary,
    Color? brandAccent,
    Color? surfaceElevated,
    Color? surfaceHover,
    Color? textTertiary,
    Color? borderFocus,
    Color? errorLight,
    Color? successLight,
    Color? warningLight,
  }) {
    return CustomColors(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      brandAccent: brandAccent ?? this.brandAccent,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceHover: surfaceHover ?? this.surfaceHover,
      textTertiary: textTertiary ?? this.textTertiary,
      borderFocus: borderFocus ?? this.borderFocus,
      errorLight: errorLight ?? this.errorLight,
      successLight: successLight ?? this.successLight,
      warningLight: warningLight ?? this.warningLight,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceHover: Color.lerp(surfaceHover, other.surfaceHover, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
    );
  }
}

class CustomTextStyles extends ThemeExtension<CustomTextStyles> {
  const CustomTextStyles({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  @override
  CustomTextStyles copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  }) {
    return CustomTextStyles(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }

  @override
  CustomTextStyles lerp(ThemeExtension<CustomTextStyles>? other, double t) {
    if (other is! CustomTextStyles) return this;
    return CustomTextStyles(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
    );
  }
}

class CustomSpacing extends ThemeExtension<CustomSpacing> {
  const CustomSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;

  @override
  CustomSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
  }) {
    return CustomSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
    );
  }

  @override
  CustomSpacing lerp(ThemeExtension<CustomSpacing>? other, double t) {
    if (other is! CustomSpacing) return this;
    return CustomSpacing(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
      xxxl: lerpDouble(xxxl, other.xxxl, t)!,
    );
  }
}

class CustomRadius extends ThemeExtension<CustomRadius> {
  const CustomRadius({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.full,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double full;

  @override
  CustomRadius copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? full,
  }) {
    return CustomRadius(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      full: full ?? this.full,
    );
  }

  @override
  CustomRadius lerp(ThemeExtension<CustomRadius>? other, double t) {
    if (other is! CustomRadius) return this;
    return CustomRadius(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      full: lerpDouble(full, other.full, t)!,
    );
  }
}

class CustomSizes extends ThemeExtension<CustomSizes> {
  const CustomSizes({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  @override
  CustomSizes copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return CustomSizes(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  CustomSizes lerp(ThemeExtension<CustomSizes>? other, double t) {
    if (other is! CustomSizes) return this;
    return CustomSizes(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
    );
  }
}

class CustomShadows extends ThemeExtension<CustomShadows> {
  const CustomShadows({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  final List<BoxShadow> xs;
  final List<BoxShadow> sm;
  final List<BoxShadow> md;
  final List<BoxShadow> lg;
  final List<BoxShadow> xl;

  @override
  CustomShadows copyWith({
    List<BoxShadow>? xs,
    List<BoxShadow>? sm,
    List<BoxShadow>? md,
    List<BoxShadow>? lg,
    List<BoxShadow>? xl,
  }) {
    return CustomShadows(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  CustomShadows lerp(ThemeExtension<CustomShadows>? other, double t) {
    if (other is! CustomShadows) return this;
    return CustomShadows(
      xs: _lerpShadowList(xs, other.xs, t),
      sm: _lerpShadowList(sm, other.sm, t),
      md: _lerpShadowList(md, other.md, t),
      lg: _lerpShadowList(lg, other.lg, t),
      xl: _lerpShadowList(xl, other.xl, t),
    );
  }

  List<BoxShadow> _lerpShadowList(List<BoxShadow> a, List<BoxShadow> b, double t) {
    if (a.length != b.length) return a;
    return List.generate(a.length, (i) => BoxShadow.lerp(a[i], b[i], t)!);
  }
}

/// Extension to access custom theme extensions easily
extension AppThemeExtensions on BuildContext {
  CustomColors get customColors => Theme.of(this).extension<CustomColors>()!;
  CustomTextStyles get customTextStyles => Theme.of(this).extension<CustomTextStyles>()!;
  CustomSpacing get customSpacing => Theme.of(this).extension<CustomSpacing>()!;
  CustomRadius get customRadius => Theme.of(this).extension<CustomRadius>()!;
  CustomSizes get customSizes => Theme.of(this).extension<CustomSizes>()!;
  CustomShadows get customShadows => Theme.of(this).extension<CustomShadows>()!;
}