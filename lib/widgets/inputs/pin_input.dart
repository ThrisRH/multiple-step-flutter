import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test/controller/otp_controller.dart';
import 'package:test/core/theme/colors.dart';

class OtpInput extends StatelessWidget {
  OtpInput({super.key});

  final OTPController controller = Get.find<OTPController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(controller.length, (index) {
        return SizedBox(
          width: 48,
          child: Obx(
            () => TextField(
              controller: controller.controllers[index],
              focusNode: controller.focusNodes[index],
              maxLength: 1,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                counterText: '',

                isDense: true,
                enabledBorder: buildBorder(
                  controller.isError.value
                      ? AppColors.error
                      : AppColors.labelGrey,
                ),
                focusedBorder: buildBorder(
                  controller.isError.value
                      ? AppColors.error
                      : AppColors.primary,
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty && index < controller.length - 1) {
                  controller.focusNodes[index + 1].requestFocus();
                } else if (value.isEmpty && index > 0) {
                  controller.focusNodes[index - 1].requestFocus();
                }

                controller.onChanged(index, value);
              },
            ),
          ),
        );
      }),
    );
  }
}

OutlineInputBorder buildBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1.5),
  );
}
