// ignore: constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:test/core/theme/colors.dart';
import 'package:test/screens/auth/register.dart';

const TEMP_OTP = "323238";

class OTPController extends GetxController {
  final int length = 6;

  final secondsLeft = 60.obs;
  final canResend = false.obs;

  final isError = false.obs;
  final canNextStep = false.obs;

  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    controllers = List.generate(length, (_) => TextEditingController());
    focusNodes = List.generate(length, (_) => FocusNode());
  }

  void startCountdown() {
    canResend.value = false;
    secondsLeft.value = 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value == 0) {
        canResend.value = true;
        timer.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  void resendOtp() {
    print("Resend OTP");
    startCountdown();
  }

  void onChanged(int index, String value) {
    if (value.length == 1 && index < length - 1) {
      focusNodes[index + 1].requestFocus();
    }

    if (getOtp().length == length) {
      if (getOtp() == TEMP_OTP) {
        isError.value = false;
        canNextStep.value = true;
      } else {
        isError.value = true;
      }
    }
  }

  void onBackspace(int index) {
    if (controllers[index].text.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String getOtp() {
    return controllers.map((c) => c.text).join();
  }

  void clear() {
    for (final c in controllers) {
      c.clear();
    }
    focusNodes.first.requestFocus();
  }

  @override
  void onClose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}

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
          height: 56,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace) {
                controller.onBackspace(index);
              }
            },
            child: Obx(
              () => TextField(
                controller: controller.controllers[index],
                focusNode: controller.focusNodes[index],
                maxLength: 1,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
                  border: buildBorder(AppColors.darkBlue),

                  focusedBorder: buildBorder(
                    controller.isError.value
                        ? AppColors.error
                        : AppColors.primary,
                  ),

                  enabledBorder: buildBorder(
                    controller.isError.value
                        ? AppColors.error
                        : AppColors.labelGrey,
                  ),
                ),
                onChanged: (value) => controller.onChanged(index, value),
              ),
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
