import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nabebank/core/theme/colors.dart';
import 'package:nabebank/screens/image_crop/index.dart';
import 'package:nabebank/widgets/buttons/index.dart';

class PermissionPopup extends StatelessWidget {
  PermissionPopup({super.key});
  final ImageCropController controller = Get.find<ImageCropController>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.6),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.all(24.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.all(24.0),
                child: Obx(() {
                  if (controller.permissionName.value == "") {
                    return SizedBox.shrink();
                  }
                  return Column(
                    spacing: 6,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "NabeBank cần quyền truy cập vào ${controller.permissionName}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Cho phép truy cập để chia sẻ ${controller.permissionName} với chúng tôi, cũng như có thể thao tác các tính năng khác cho hình ảnh của bạn.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.labelGrey,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: controller.closePopup,
                              child: Text(
                                'Từ chối',
                                style: TextStyle(color: AppColors.darkBlue),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Obx(
                              () => AppButton(
                                onTap: controller.request,
                                label:
                                    controller.photoStatus.value ==
                                        PermissionStatus.permanentlyDenied
                                    ? "Đi đến cài đặt"
                                    : "Cấp quyền",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
