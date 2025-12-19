import 'package:flutter/material.dart';
import 'package:test/core/theme/colors.dart';

class ManagerLayout extends StatelessWidget {
  final String title;
  final Widget child;
  const ManagerLayout({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: child,
    );
  }
}
