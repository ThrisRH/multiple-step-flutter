import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabebank/core/theme/colors.dart';
import 'package:nabebank/screens/image_crop/index.dart';
import 'package:nabebank/screens/image_crop/permission_popup.dart';

class ManagerLayout extends StatelessWidget {
  final String title;
  final Widget child;
  ManagerLayout({super.key, required this.title, required this.child});
  final ImageCropController controller = Get.find<ImageCropController>();

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: currentRoute != "/user-manager"
                ? GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.white,
                    ),
                  )
                : null,
            title: Text(title, style: TextStyle(color: AppColors.white)),
            backgroundColor: AppColors.primary,
          ),
          body: child,
        ),
        Positioned.fill(
          child: Obx(
            () => controller.showPopup.value
                ? PermissionPopup()
                : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
