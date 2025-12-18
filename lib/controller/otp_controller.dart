// ignore: constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test/controller/ocr_controller.dart';
import 'package:test/controller/register_controller.dart';
import 'package:test/core/utils/hash_password.dart';
import 'package:test/model/id_card_model.dart';

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

    ever(canNextStep, (_) async {
      if (canNextStep.value) {
        final RegisterStepController registerStepController =
            Get.find<RegisterStepController>();
        await onSubmit(registerStepController);
        await registerStepController.loadRegisterRequest();
        await registerStepController.nextStep();
      }
    });

    controllers = List.generate(length, (_) => TextEditingController());
    focusNodes = List.generate(length, (_) => FocusNode());
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

    final otp = controllers.map((c) => c.text).join();

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

  // Reset
  void reset() {
    clear();

    resendTimer?.cancel();
    lockTimer?.cancel();

    secondsLeft.value = 60;
    canResend.value = false;
    isError.value = false;
    errorMessage.value = "";
    canNextStep.value = false;
    failedCount.value = 0;
    lockedTime.value = 0;
  }

  // Submit form after validate OTP succeed
  Future<void> onSubmit(RegisterStepController controller) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final OCRScannerController ocrScannerController =
          Get.find<OCRScannerController>();

      final registerRequest = RegisterRequest(
        phone: controller.phoneNumberController.text,
        password: hashPassword(controller.passwordController.text),
        data: ocrScannerController.ocrResult.value!.data,
      );

      exportRegisterJson(registerRequest);
    } catch (e) {
      errorMessage.value = "Đăng ký thất bại. Vui lòng thử lại sau.";
    }
  }

  // JSON handle
  Future<File> exportRegisterJson(RegisterRequest data) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/register_request.json');

    final jsonString = jsonEncode(data.toJson());
    return file.writeAsString(jsonString);
  }

  Future<RegisterRequest?> readRegisterJson() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/register_request.json');

    if (!file.existsSync()) return null;

    final jsonString = await file.readAsString();
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    return RegisterRequest.fromJson(jsonMap);
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
