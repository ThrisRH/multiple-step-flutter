import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test/controller/register_controller.dart';
import 'package:test/core/theme/colors.dart';
import 'package:test/screens/manager/permission_manager.dart';
import 'package:test/widgets/buttons/index.dart';
import 'package:test/widgets/common/error_message.dart';
import 'package:test/widgets/inputs/index.dart';

class PhoneNumberStep extends StatelessWidget {
  final Function(String) phoneOnChanged;
  final Function(String) emailOnChanged;

  PhoneNumberStep({
    super.key,
    required this.phoneOnChanged,
    required this.emailOnChanged,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              NormalInput(
                label: "Số điện thoại",
                hint: "Nhập số điện thoại",
                controller: controller.phoneNumberController,
                onChanged: phoneOnChanged,
                maxLength: 12,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              NormalInput(
                label: "Email",
                hint: "Nhập email",
                controller: controller.emailController,
                onChanged: emailOnChanged,
              ),

              // Error warning
              ErrorText(controller.errorMessage),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.agreeTerm.value,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      onChanged: (val) =>
                          controller.agreeTerm.value = val ?? false,
                      fillColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primary;
                        }
                        return Colors.transparent;
                      }),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      softWrap: true,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Tôi đồng ý với ",
                            style: TextStyle(color: AppColors.black),
                          ),
                          TextSpan(
                            text: "Điều khoản sử dụng ",
                            style: TextStyle(color: AppColors.darkBlue),
                          ),
                          TextSpan(
                            text: "và ",
                            style: TextStyle(color: AppColors.black),
                          ),
                          TextSpan(
                            text: "Chính sách bảo mật ",
                            style: TextStyle(color: AppColors.darkBlue),
                          ),
                          TextSpan(
                            text: "của ngân hàng",
                            style: TextStyle(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Obx(() {
          return Column(
            children: [
              AppButton(
                disabled:
                    controller.phoneNumber.value.length < 10 ||
                    controller.email.value == "" ||
                    !controller.agreeTerm.value,
                onTap: () {
                  controller.nextStep();
                },
                label: "Đăng ký",
              ),

              TextButton(
                onPressed: () => Get.offAll(
                  PermissionScreen(),
                  transition: Transition.noTransition,
                ),
                child: Text(
                  "Trở về",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
