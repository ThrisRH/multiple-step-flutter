import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/core/theme/colors.dart';
import 'package:test/screens/auth/register.dart';
import 'package:test/widgets/buttons/index.dart';
import 'package:test/widgets/common/error_message.dart';
import 'package:test/widgets/inputs/index.dart';

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
        Row(
          spacing: 24,
          children: [
            GestureDetector(
              onTap: controller.prevStep,
              child: Icon(Icons.arrow_back_ios_new, color: AppColors.darkBlue),
            ),
            const Text(
              "Tạo mật khẩu",
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
                    children: [
                      const Text(
                        "• ",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.labelGrey,
                        ),
                      ),
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

        AppButton(
          onTap: () {
            controller.nextStep();
          },
          label: "Tạo mật khẩu",
        ),
      ],
    );
  }
}
