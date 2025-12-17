import 'dart:ui';

class AppColors {
  static const primary = Color(0xFF0047AB);
  static const secondary = Color(0xFFE5C100);

  // text
  static const darkBlue = Color(0xFF2D4769);
  static const labelGrey = Color(0xFF8291A6);
  static const placeHolder = Color(0xFF8C8C8C);
  static const inputPlaceHolder = Color(0xFFA6A6A6);

  // neutral
  static const black = Color(0xFF1C1C1C);
  static const white = Color(0xFFF9F9F9);

  // status
  static const success = Color(0xFF00B400);
  static const error = Color(0xFFFF0033);
  static const inactive = Color(0xFFD1D1D6);
  static const inputDisable = Color(0xFFEBEBEB);
  static const warning = Color(0xFFE5C100);

  // theme
  static final border = const Color(0xFF2D4769).withValues(alpha: 0.7);
  static final opacityBackground = const Color(
    0xFFEEF5FF,
  ).withValues(alpha: 0.4);
  static final borderMoreOpacity = const Color(
    0xFF2D4769,
  ).withValues(alpha: 0.15);
  static final overlay = const Color(0xFF000000).withValues(alpha: 0.4);
}
