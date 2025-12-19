import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/core/theme/colors.dart';

class ManagerLayout extends StatelessWidget {
  final String title;
  final Widget child;
  const ManagerLayout({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    return Scaffold(
      appBar: AppBar(
        leading: currentRoute != "/user-manager"
            ? GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back_ios_new, color: AppColors.white),
              )
            : null,
        title: Text(title, style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: child,
    );
  }
}
