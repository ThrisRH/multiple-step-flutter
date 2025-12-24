import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabebank/controller/ocr_controller.dart';
import 'package:nabebank/controller/register_controller.dart';
import 'package:nabebank/core/theme/colors.dart';
import 'package:nabebank/widgets/common/dot.dart';
import 'package:nabebank/widgets/inputs/index.dart';
import 'package:nabebank/widgets/layout/multiple_form/action.dart';

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
    if (ocrScannerController.ocrResult.value == null) return Container();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          Column(
            spacing: 12,
            children: [
              NormalInput(
                controller: ocrScannerController.nameController,
                label: "Họ và tên",
                hint: "Nhập họ và tên",
                onChanged: (val) =>
                    ocrScannerController.nameController.text = val,
              ),

              Row(
                spacing: 12,
                children: [
                  Flexible(
                    flex: 3,
                    child: NormalInput(
                      controller: ocrScannerController.dobController,
                      label: "Ngày sinh",
                      hint: "Nhập ngày sinh",
                      onChanged: (val) =>
                          ocrScannerController.dobController.text = val,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: NormalInput(
                      controller: ocrScannerController.sexController,
                      label: "Giới tính",
                      hint: "Giới tính",
                      onChanged: (val) =>
                          ocrScannerController.sexController.text = val,
                    ),
                  ),
                ],
              ),

              Row(
                spacing: 12,
                children: [
                  Flexible(
                    flex: 3,
                    child: NormalInput(
                      controller: ocrScannerController.idNumberController,
                      label: "Số CCCD/CMND",
                      hint: "Nhập số CCCD/CMND",
                      onChanged: (val) =>
                          ocrScannerController.idNumberController.text = val,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: NormalInput(
                      controller: ocrScannerController.doeController,
                      label: "Ngày hết hạn",
                      hint: "Nhập ngày hết hạn",
                      onChanged: (val) =>
                          ocrScannerController.doeController.text = val,
                    ),
                  ),
                ],
              ),

              NormalInput(
                controller: ocrScannerController.addressController,
                label: "Địa chỉ thường trú",
                hint: "Nhập địa chỉ thường trú",
                onChanged: (val) =>
                    ocrScannerController.addressController.text = val,
              ),

              NormalInput(
                controller: ocrScannerController.homeController,
                label: "Nguyên quán",
                hint: "Nguyên quán",
                onChanged: (val) =>
                    ocrScannerController.homeController.text = val,
              ),

              NormalInput(
                controller: ocrScannerController.nationalityController,
                label: "Quốc tịch",
                hint: "Quốc tịch",
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

          Obx(
            () => ActionWrapper(
              onBack: registerStepController.prevStep,
              onNext: registerStepController.nextStep,
              canNext: ocrScannerController.isAllFieldsFilled,
              label: "Mọi thông tin đều đúng",
            ),
          ),
        ],
      ),
    );
  }
}
