import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/controller/register_controller.dart';
import 'package:test/core/config/register_step_config.dart';
import 'package:test/screens/auth/widgets/register/citizen_card_step.dart';
import 'package:test/screens/auth/widgets/register/ocr_info_step.dart';
import 'package:test/screens/auth/widgets/register/otp_step.dart';
import 'package:test/screens/auth/widgets/register/password_step.dart';
import 'package:test/screens/auth/widgets/register/phone_number_step.dart';
import 'package:test/screens/auth/widgets/register/success_step.dart';
import 'package:test/widgets/layout/multiple_form/index.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final RegisterStepController registerStepController = Get.put(
    RegisterStepController(),
  );

  @override
  Widget build(BuildContext context) {
    final stepsList = [
      RegisterStepConfig(
        page: PhoneNumberStep(
          phoneOnChanged: (val) {
            registerStepController.phoneNumber.value = val;
          },
          emailOnChanged: (val) {
            registerStepController.email.value = val;
          },
        ),

        label: "Đăng ký bằng số điện thoại và email",
        haveBackToPrev: false,
      ),

      RegisterStepConfig(
        page: PasswordStep(
          passwordOnChanged: (val) {
            registerStepController.password.value = val;
          },
          confirmPasswordOnChanged: (val) {
            registerStepController.confirmPassword.value = val;
          },
        ),

        label: "Tạo mật khẩu",
      ),

      RegisterStepConfig(
        page: Obx(() {
          return CitizenCardStep(
            image: registerStepController.image.value,
            haveImage: registerStepController.image.value != null,
            onTap: () => registerStepController.pickGallery(),
          );
        }),

        label: "Xác minh danh tính",
      ),

      RegisterStepConfig(page: OcrInfoStep(), label: "Xác nhận thông tin"),

      RegisterStepConfig(page: OTPStep(), label: "Xác thực OTP"),

      RegisterStepConfig(
        page: SuccessStep(),
        label: "Đăng ký hoàn tất",
        haveBackToPrev: false,
      ),
    ];

    return RegisterMainLayout(
      stepsList: stepsList,
      controller: registerStepController,
    );
  }
}
