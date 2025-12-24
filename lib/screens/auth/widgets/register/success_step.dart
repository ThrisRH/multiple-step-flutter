import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabebank/controller/ocr_controller.dart';
import 'package:nabebank/controller/otp_controller.dart';
import 'package:nabebank/controller/register_controller.dart';
import 'package:nabebank/core/theme/colors.dart';
import 'package:nabebank/widgets/buttons/index.dart';
import 'package:nabebank/widgets/common/info_container.dart';
import 'package:nabebank/widgets/common/info_row.dart';

class SuccessStep extends StatelessWidget {
  SuccessStep({super.key});
  final OCRScannerController ocrScannerController =
      Get.find<OCRScannerController>();
  final OTPController otpController = Get.find<OTPController>();
  final RegisterStepController registerStepController =
      Get.find<RegisterStepController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!registerStepController.isSuccessReady) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          Expanded(
            child: Column(
              spacing: 12,
              children: [
                // Thông tin cá nhân từ OCR
                InfoBoxContainer(
                  title: "Thông tin đã đăng ký",
                  children: [
                    InfoRow(
                      "Số điện thoại",
                      registerStepController.phoneNumberController.text,
                    ),
                    InfoRow(
                      "Email",
                      registerStepController.emailController.text,
                    ),
                    InfoRow(
                      "Họ và tên",
                      ocrScannerController.nameController.text,
                    ),
                    InfoRow(
                      "Ngày sinh",
                      ocrScannerController.dobController.text,
                    ),
                    InfoRow(
                      "Địa chỉ thường trú",
                      ocrScannerController.addressController.text,
                    ),
                    InfoRow(
                      "Nguyên quán",
                      ocrScannerController.homeController.text,
                    ),
                    InfoRow(
                      "Giới tính",
                      ocrScannerController.sexController.text,
                    ),
                    InfoRow(
                      "Quốc tịch",
                      ocrScannerController.nationalityController.text,
                    ),
                    InfoRow(
                      "Số CCCD/CMND",
                      ocrScannerController.idNumberController.text,
                    ),
                    InfoRow(
                      "Ngày hết hạn",
                      ocrScannerController.doeController.text,
                    ),
                  ],
                ),

                // Thông báo thành công
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    spacing: 12,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 24,
                      ),
                      Expanded(
                        child: Text(
                          "Đăng ký tài khoản thành công! Bạn có thể bắt đầu sử dụng ứng dụng ngay bây giờ.",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          AppButton(
            onTap: () {
              otpController.reset();
              registerStepController.resetToPhoneNumberStep();
            },
            label: "Bắt đầu sử dụng",
          ),
        ],
      );
    });
  }
}
