import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test/controller/ocr_controller.dart';
import 'package:test/controller/otp_controller.dart';
import 'package:test/model/id_card_model.dart';

class RegisterStepController extends GetxController {
  Rx<File?> image = Rx<File?>(null);
  final Rxn<RegisterRequest> registerRequestData = Rxn<RegisterRequest>();

  final ImagePicker picker = ImagePicker();
  final PageController pageController = PageController();

  final index = 0.obs;
  final agreeTerm = false.obs;
  final errorMessage = "".obs;

  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final phoneNumber = "".obs;
  final password = "".obs;
  final confirmPassword = "".obs;

  final OCRScannerController ocrScannerController =
      Get.find<OCRScannerController>();
  final OTPController otpController = Get.put(OTPController());

  late final List<Future<bool> Function()> validators;

  bool get isSuccessReady =>
      registerRequestData.value != null &&
      ocrScannerController.ocrResult.value?.data != null;

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
  bool validatePhone() {
    String pattern = r'^(?:\+84|84|0)(3|5|7|8|9)\d{8,9}$';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(phoneNumberController.text)) {
      errorMessage.value = "Số điện thoại không hợp lệ";
      return false;
    }

    if (!agreeTerm.value) {
      errorMessage.value = "Vui lòng chấp nhận điều khoản sử dụng để tiếp tục.";
      return false;
    }
    return true;
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

  // Load data of submit form
  Future<void> loadRegisterRequest() async {
    final data = await otpController.readRegisterJson();
    registerRequestData.value = data;
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
    registerRequestData.value = null;

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
