import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/controller/ocr_controller.dart';
import 'package:test/core/theme/colors.dart';
import 'package:test/screens/auth/register.dart';
import 'package:test/widgets/buttons/index.dart';
import 'package:test/widgets/common/dot.dart';
import 'package:test/widgets/inputs/index.dart';

// ignore: constant_identifier_names
const CONFIRM_INFO_DISCLAIMER = [
  "Vui lòng kiểm tra lại toàn bộ thông tin cá nhân trước khi xác nhận.",
  "Mọi sai lệch hoặc thiếu chính xác trong thông tin do khách hàng cung cấp sẽ do khách hàng tự chịu trách nhiệm.",
];

class OcrInfoStep extends StatelessWidget {
  OcrInfoStep({super.key});
  final OCRScannerController ocrScannerController =
      Get.find<OCRScannerController>();
  final RegisterStepController registerStepController =
      Get.find<RegisterStepController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ocrScannerController.ocrResult.value == null) return Container();
      final info = ocrScannerController.ocrResult.value!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          Row(
            spacing: 24,
            children: [
              GestureDetector(
                onTap: registerStepController.prevStep,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.darkBlue,
                ),
              ),
              const Text(
                "Xác nhận thông tin",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),

          Expanded(
            child: Column(
              spacing: 12,
              children: [
                NormalInput(
                  controller: TextEditingController(text: info.data.name),
                  label: "Họ và tên",
                  hint: "Nhập họ và tên",
                  onChanged: (val) => {},
                ),

                NormalInput(
                  controller: TextEditingController(text: info.data.dob),
                  label: "Ngày sinh",
                  hint: "Nhập ngày sinh",
                  onChanged: (val) => {},
                ),

                Row(
                  spacing: 12,
                  children: [
                    Flexible(
                      flex: 3,
                      child: NormalInput(
                        controller: TextEditingController(text: info.data.id),
                        label: "Số CCCD/CMND",
                        hint: "Nhập số CCCD/CMND",
                        onChanged: (val) => {},
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: NormalInput(
                        controller: TextEditingController(text: info.data.doe),
                        label: "Ngày hết hạn",
                        hint: "Nhập ngày hết hạn",
                        onChanged: (val) => {},
                      ),
                    ),
                  ],
                ),

                NormalInput(
                  controller: TextEditingController(text: info.data.address),
                  label: "Địa chỉ thường trú",
                  hint: "Nhập địa chỉ thường trú",
                  onChanged: (val) => {},
                ),

                Column(
                  spacing: 6,
                  children: CONFIRM_INFO_DISCLAIMER.map((item) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Dot(size: 4, color: AppColors.inactive),
                        Expanded(
                          child: Text(
                            item,
                            softWrap: true,
                            style: TextStyle(
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

          AppButton(
            onTap: () {
              registerStepController.nextStep();
            },
            label: "Mọi thông tin hoàn toàn đúng.",
          ),
        ],
      );
    });
  }
}
