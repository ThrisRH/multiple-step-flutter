import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabebank/controller/ocr_controller.dart';
import 'package:nabebank/controller/register_controller.dart';
import 'package:nabebank/core/theme/colors.dart';
import 'package:nabebank/widgets/common/error_message.dart';
import 'package:nabebank/widgets/layout/multiple_form/action.dart';

// ignore: constant_identifier_names
const ID_CARD_RULE = [
  "Rõ nét, không bị mờ",
  "Không che tay",
  "Đủ ánh sáng",
  "Hiển thị đầy đủ thông tin",
];

class CitizenCardStep extends StatelessWidget {
  final VoidCallback onTap;
  final bool haveImage;
  final File? image;
  CitizenCardStep({
    super.key,
    required this.image,
    required this.haveImage,
    required this.onTap,
  });

  final RegisterStepController registerStepController =
      Get.find<RegisterStepController>();
  final OCRScannerController ocrScannerController =
      Get.find<OCRScannerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ocrScannerController.isLoading.value) {
        CircularProgressIndicator();
      }

      return Column(
        children: [
          SizedBox(height: 24),

          Expanded(
            child: Column(
              children: [
                haveImage && image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          image!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                      )
                    : GestureDetector(
                        onTap: onTap,
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            dashPattern: [10, 5],
                            strokeWidth: 1,
                            padding: EdgeInsets.all(16),
                            radius: Radius.circular(12),
                          ),
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 12,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: AppColors.primary,
                                    size: 64,
                                  ),
                                  Text(
                                    'Mặt trước CCCD / CMND',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.darkBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                SizedBox(height: 24),

                const Text(
                  "Vui lòng chụp mặt trước CCCD / CMND để tiếp tục.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.darkBlue),
                ),

                SizedBox(height: 12),

                // Error
                ErrorText(registerStepController.errorMessage),

                SizedBox(height: 24),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: ID_CARD_RULE.map((rule) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 12,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                        ),
                        Expanded(
                          child: Text(
                            rule,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          Obx(
            () => ActionWrapper(
              onBack: registerStepController.prevStep,
              onNext: registerStepController.nextStep,
              canNext: ocrScannerController.ocrResult.value != null,
              label: "Xác nhận",
            ),
          ),
        ],
      );
    });
  }
}
