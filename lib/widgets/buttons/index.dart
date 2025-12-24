import 'package:flutter/material.dart';
import 'package:nabebank/core/theme/colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool disabled;

  const AppButton({
    super.key,
    required this.onTap,
    required this.label,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: disabled ? AppColors.inactive : AppColors.primary,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class AppBorderButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool disabled;

  const AppBorderButton({
    super.key,
    required this.onTap,
    required this.label,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.transparent,
          border: Border.all(color: AppColors.primary),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
