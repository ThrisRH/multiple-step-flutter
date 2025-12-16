import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test/controller/ocr_controller.dart';
import 'package:test/core/theme/colors.dart';
import 'package:test/screens/auth/widgets/register/citizen_card_step.dart';
import 'package:test/screens/auth/widgets/register/ocr_info_step.dart';
import 'package:test/screens/auth/widgets/register/otp_step.dart';
import 'package:test/screens/auth/widgets/register/password_step.dart';
import 'package:test/screens/auth/widgets/register/phone_number_step.dart';
import 'package:test/screens/auth/widgets/register/success_step.dart';
import 'package:test/widgets/inputs/pin_input.dart';

class RegisterStepController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final PageController pageController = PageController();
  Rx<File?> image = Rx<File?>(null);

  final index = 0.obs;
  final agreeTerm = false.obs;
  final errorMessage = "".obs;

  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final OCRScannerController ocrScannerController =
      Get.find<OCRScannerController>();
  final OTPController otpController = Get.put(OTPController());

  late final List<bool Function()> validators;

  @override
  void onInit() {
    super.onInit();

    validators = [
      validatePhone,
      validatePassword,
      validateImage,
      validateInfo,
      validatedOTP,
      validateSuccess,
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

  void nextStep() {
    if (validators[index.value]()) {
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

  bool validateInfo() {
    return true;
  }

  bool validatedOTP() {
    return true;
  }

  bool validateSuccess() {
    return true;
  }

  @override
  void onClose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

class Register extends StatelessWidget {
  Register({super.key});

  final RegisterStepController registerStepController = Get.put(
    RegisterStepController(),
  );
  final OCRScannerController ocrScannerController =
      Get.find<OCRScannerController>();

  @override
  Widget build(BuildContext context) {
    final stepsList = [
      PhoneNumberStep(
        onChanged: (val) {
          registerStepController.phoneNumberController.text = val;
        },
      ),

      PasswordStep(
        passwordOnChanged: (pass) {
          registerStepController.passwordController.text = pass;
        },
        confirmPasswordOnChanged: (cfPass) {
          registerStepController.confirmPasswordController.text = cfPass;
        },
      ),

      Obx(() {
        return CitizenCardStep(
          image: registerStepController.image.value,
          haveImage: registerStepController.image.value != null,
          onTap: () => registerStepController.pickGallery(),
        );
      }),

      OcrInfoStep(),

      OTPStep(),

      SuccessStep(),
    ];

    return Scaffold(
      body: Obx(() {
        final isLoading = ocrScannerController.isLoading.value;

        return Stack(
          children: [
            AbsorbPointer(
              absorbing: isLoading,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  spacing: 24,
                  children: [
                    if (registerStepController.index.value <
                        stepsList.length - 1)
                      LinearProgressIndicator(
                        value:
                            ((registerStepController.index.value + 1) /
                                    stepsList.length)
                                .clamp(0.0, 1.0),

                        color: AppColors.primary,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(12),
                      ),

                    Expanded(
                      child: PageView(
                        controller: registerStepController.pageController,
                        physics: NeverScrollableScrollPhysics(),
                        children: stepsList,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
