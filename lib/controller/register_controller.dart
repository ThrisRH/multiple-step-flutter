import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nabebank/controller/ocr_controller.dart';
import 'package:nabebank/controller/otp_controller.dart';
import 'package:nabebank/service/register_service.dart';
import 'package:nabebank/widgets/layout/multiple_form/index.dart';

class RegisterStepController extends GetxController {
  final ImagePicker picker = ImagePicker();
  Rx<File?> image = Rx<File?>(null);

  final PageController pageController = PageController();
  final OCRScannerController ocrScannerController =
      Get.find<OCRScannerController>();
  final OTPController otpController = Get.put(OTPController());
  final LoadingController loadingController = Get.find<LoadingController>();

  final index = 0.obs;
  final agreeTerm = false.obs;
  final errorMessage = "".obs;

  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final phoneNumber = "".obs;
  final email = "".obs;
  final password = "".obs;
  final confirmPassword = "".obs;

  final userService = UserService();

  late final List<Future<bool> Function()> validators;

  bool get isSuccessReady => ocrScannerController.ocrResult.value?.data != null;

  @override
  void onInit() {
    super.onInit();

    phoneNumberController.text = phoneNumber.value;
    passwordController.text = password.value;
    confirmPasswordController.text = confirmPassword.value;

    validators = [
      () async => validatePhone(),
      () async => validatePassword(),
      () async => validateImage(),
      () async => true, // OCR Info Checking (Setup later)
      () async => true, // OTP
      () async => true, // Success Screen
    ];
  }

  // Pick image
  Future pickGallery() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      image.value = File(picked.path);

      ocrScannerController.scanImage(image.value!);
    }
  }

  Future<void> nextStep() async {
    final isValid = await validators[index.value]();

    if (isValid) {
      errorMessage.value = "";
      index.value++;

      pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void prevStep() {
    if (index.value > 0) {
      errorMessage.value = "";
      index.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  // Check phone step
  Future<bool> validatePhone() async {
    String pattern = r'^(?:\+84|84|0)(3|5|7|8|9)\d{8,9}$';
    RegExp regExp = RegExp(pattern);

    try {
      loadingController.isLoading.value = true;
      if (!regExp.hasMatch(phoneNumberController.text)) {
        errorMessage.value = "Số điện thoại không hợp lệ";
        return false;
      }

      if (!agreeTerm.value) {
        errorMessage.value =
            "Vui lòng chấp nhận điều khoản sử dụng để tiếp tục.";
        return false;
      }

      if (await userService.checkValidPhoneEmail(
        phoneNumber.value,
        email.value,
      )) {
        errorMessage.value = "Số điện thoại hoặc mật khẩu đã được sử dụng.";
        return false;
      }

      return true;
    } finally {
      loadingController.isLoading.value = false;
    }
  }

  // Check password step
  bool validatePassword() {
    String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (passwordController.text == "" || passwordController.text.isEmpty) {
      errorMessage.value = "Không được để trống. Vui lòng nhập mật khẩu";
      return false;
    }

    if (!regExp.hasMatch(passwordController.text)) {
      errorMessage.value = "Mật khẩu chưa an toàn. Vui lòng thử mật khẩu khác.";
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value =
          "Mật khẩu nhập lại chưa trùng khớp. Vui lòng thử lại.";
      return false;
    }

    return true;
  }

  // Check image
  bool validateImage() {
    if (ocrScannerController.ocrResult.value == null) {
      errorMessage.value =
          "Không tìm thấy ảnh hoặc xác thực không thành công. Vui lòng thử lại.";
      return false;
    }

    // Send OTP function here
    otpController.startCountdown();
    return true;
  }

  // Reset form
  void resetToPhoneNumberStep() {
    index.value = 0;

    phoneNumberController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    agreeTerm.value = false;
    errorMessage.value = "";
    image.value = null;

    ocrScannerController.ocrResult.value = null;
    otpController.reset();

    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
