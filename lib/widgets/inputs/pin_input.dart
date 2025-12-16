// ignore: constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test/core/theme/colors.dart';
import 'package:test/screens/auth/register.dart';

// ignore: constant_identifier_names
const TEMP_OTP = "323238";

class OTPController extends GetxController {
  final int length = 6;

  final secondsLeft = 60.obs;
  final canResend = false.obs;

  final isError = false.obs;
  final errorMessage = "".obs;
  final canNextStep = false.obs;

  final failedCount = 0.obs;
  final lockedTime = 0.obs;

  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  Timer? resendTimer;
  Timer? lockTimer;

  @override
  void onInit() {
    super.onInit();

    ever(canNextStep, (_) {
      if (canNextStep.value) {
        Get.find<RegisterStepController>().nextStep();
      }
    });

    controllers = List.generate(length, (_) => TextEditingController());
    focusNodes = List.generate(length, (_) => FocusNode());
  }

  String getOtp() {
    return controllers.map((c) => c.text).join();
  }

  void startCountdown() {
    canResend.value = false;
    secondsLeft.value = 60;

    resendTimer?.cancel();
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value == 0) {
        canResend.value = true;
        timer.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  void startLockedCountdown() {
    canResend.value = false;
    lockedTime.value = 120;

    lockTimer?.cancel();
    lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (lockedTime.value == 0) {
        canResend.value = true;
        failedCount.value = 0;
        timer.cancel();
      } else {
        lockedTime.value--;
      }
    });
  }

  void resendOtp() {
    if (secondsLeft.value <= 0 && lockedTime.value <= 0) {
      startCountdown();
    }
  }

  void onChanged(int index, String value) {
    if (value.length == 1 && index < length - 1) {
      focusNodes[index + 1].requestFocus();
    }

    final otp = getOtp();

    if (otp.length < length) {
      isError.value = false;
      canNextStep.value = false;
      return;
    }

    // Validate
    if (failedCount.value >= 5) {
      startLockedCountdown();
      errorMessage.value =
          "Bạn đã nhập sai mã OTP quá nhiều lần. Vui lòng thử lại sau.";
      return;
    } else if (otp == TEMP_OTP) {
      isError.value = false;
      canNextStep.value = true;
    } else {
      isError.value = true;
      canNextStep.value = false;
      failedCount.value++;
      clear();
    }
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
