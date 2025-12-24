// ignore: constant_identifier_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabebank/controller/ocr_controller.dart';
import 'package:nabebank/controller/register_controller.dart';
import 'package:nabebank/core/utils/hash_password.dart';
import 'package:nabebank/model/id_card_model.dart';
import 'package:nabebank/service/register_service.dart';
import 'package:nabebank/widgets/layout/multiple_form/index.dart';

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

  final userService = UserService();

  final LoadingController loadingController = Get.find<LoadingController>();

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
    loadingController.isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final OCRScannerController ocrScannerController =
          Get.find<OCRScannerController>();

      final PersonalInformation payload = PersonalInformation(
        idCard: ocrScannerController.idNumberController.text,
        name: ocrScannerController.nameController.text,
        dob: ocrScannerController.dobController.text,
        sex: ocrScannerController.sexController.text,
        nationality: ocrScannerController.nationalityController.text,
        home: ocrScannerController.homeController.text,
        address: ocrScannerController.addressController.text,
        doe: ocrScannerController.doeController.text,
        addressEntities:
            ocrScannerController.ocrResult.value!.data.addressEntities,
      );

      final registerRequest = RegisterRequest(
        phone: controller.phoneNumberController.text,
        email: controller.emailController.text,
        password: hashPassword(controller.passwordController.text),
        personalInformation: payload,
      );

      final response = await userService.registerAccount(registerRequest);

      if (response['isSuccess'] == false) {
        Get.snackbar("Đăng ký thất bại!", response['errorMessage']);
      } else {
        Get.snackbar(
          "Đăng ký thành công!",
          "Chúc mừng bạn đã đăng ký thành công.",
        );
      }
    } catch (e) {
      errorMessage.value = "Đăng ký thất bại. Vui lòng thử lại sau.";
    } finally {
      loadingController.isLoading.value = false;
    }
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
