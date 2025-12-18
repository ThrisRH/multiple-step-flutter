import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/controller/register_controller.dart';
import 'package:test/core/theme/colors.dart';
import 'package:test/widgets/common/dot.dart';
import 'package:test/widgets/common/error_message.dart';
import 'package:test/widgets/inputs/index.dart';
import 'package:test/widgets/layout/multiple_form/action.dart';

// ignore: constant_identifier_names
const PASSWORD_RULE = [
  "Ít nhất 8 ký tự",
  "Có ít nhất 1 chữ hoa (A-Z)",
  "Có ít nhất 1 chữ số (0-9)",
  "Có 1 ký tự đặc biệt (ví dụ: ! @ # %)",
];

class PasswordStep extends StatelessWidget {
  final Function(String) passwordOnChanged;
  final Function(String) confirmPasswordOnChanged;
  PasswordStep({
    super.key,
    required this.passwordOnChanged,
    required this.confirmPasswordOnChanged,
  });
  final RegisterStepController controller = Get.find<RegisterStepController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24,
      children: [
        Expanded(
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PasswordInput(
                label: "Mật khẩu",
                hint: "Mật khẩu",
                controller: controller.passwordController,
                onChanged: passwordOnChanged,
              ),

              PasswordInput(
                label: "Nhập lại mật khẩu",
                hint: "Nhập lại mật khẩu",
                controller: controller.confirmPasswordController,
                onChanged: confirmPasswordOnChanged,
              ),

              // Error
              ErrorText(controller.errorMessage),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: PASSWORD_RULE.map((rule) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Dot(size: 4, color: AppColors.inactive),
                      Expanded(
                        child: Text(
                          rule,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.labelGrey,
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
            onBack: controller.prevStep,
            onNext: controller.nextStep,
            canNext:
                (controller.password.value != "" &&
                controller.confirmPassword.value != "" &&
                controller.password.value == controller.confirmPassword.value),
            label: "Tạo mật khẩu",
          ),
        ),
      ],
    );
  }
}
