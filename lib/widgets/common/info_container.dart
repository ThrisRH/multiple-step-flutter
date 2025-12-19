import 'package:flutter/material.dart';
import 'package:test/core/theme/colors.dart';

class InfoBoxContainer extends StatelessWidget {
  final List<Widget> children;
  final String title;
  const InfoBoxContainer({
    super.key,
    required this.children,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.opacityBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderMoreOpacity),
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.darkBlue,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: children,
          ),
        ],
      ),
    );
  }
}
