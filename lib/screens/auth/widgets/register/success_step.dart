import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/controller/ocr_controller.dart';
import 'package:test/controller/otp_controller.dart';
import 'package:test/controller/register_controller.dart';
import 'package:test/core/theme/colors.dart';
import 'package:test/widgets/buttons/index.dart';

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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.opacityBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderMoreOpacity),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Text(
                        "Thông tin đã đăng ký",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkBlue,
                        ),
                      ),

                      _buildInfoRow(
                        "Số điện thoại",
                        registerStepController.phoneNumberController.text,
                      ),
                      _buildInfoRow(
                        "Email",
                        registerStepController.emailController.text,
                      ),
                      _buildInfoRow(
                        "Họ và tên",
                        ocrScannerController.nameController.text,
                      ),
                      _buildInfoRow(
                        "Ngày sinh",
                        ocrScannerController.dobController.text,
                      ),
                      _buildInfoRow(
                        "Địa chỉ thường trú",
                        ocrScannerController.addressController.text,
                      ),
                      _buildInfoRow(
                        "Nguyên quán",
                        ocrScannerController.homeController.text,
                      ),
                      _buildInfoRow(
                        "Giới tính",
                        ocrScannerController.sexController.text,
                      ),
                      _buildInfoRow(
                        "Quốc tịch",
                        ocrScannerController.nationalityController.text,
                      ),
                      _buildInfoRow(
                        "Số CCCD/CMND",
                        ocrScannerController.idNumberController.text,
                      ),
                      _buildInfoRow(
                        "Ngày hết hạn",
                        ocrScannerController.doeController.text,
                      ),
                    ],
                  ),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: AppColors.labelGrey),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 14, color: AppColors.black),
          ),
        ),
      ],
    );
  }
}
