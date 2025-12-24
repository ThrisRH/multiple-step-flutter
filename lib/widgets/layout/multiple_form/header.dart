import 'package:flutter/material.dart';
import 'package:nabebank/core/theme/colors.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onTap;
  final bool haveBackToPrev;
  final String label;
  const AppHeader({
    super.key,
    this.onTap,
    required this.label,
    this.haveBackToPrev = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 24,
      children: [
        if (haveBackToPrev)
          GestureDetector(
            onTap: onTap,
            child: Icon(Icons.arrow_back_ios_new, color: AppColors.darkBlue),
          ),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
      ],
    );
  }
}
