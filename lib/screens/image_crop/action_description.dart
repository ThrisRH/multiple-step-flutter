import 'package:flutter/material.dart';
import 'package:nabebank/core/theme/colors.dart';

class ActionDescription extends StatelessWidget {
  final String title, guide, imagePath;
  const ActionDescription({
    super.key,
    required this.title,
    required this.guide,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Image.asset(imagePath),
        Text(
          guide,
          style: TextStyle(fontSize: 14, color: AppColors.labelGrey, height: 2),
        ),
      ],
    );
  }
}
