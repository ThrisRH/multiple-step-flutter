import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/core/theme/colors.dart';
import 'package:test/screens/auth/register.dart';
import 'package:test/widgets/common/error_message.dart';
import 'package:test/widgets/inputs/pin_input.dart';

class OTPStep extends StatelessWidget {
  OTPStep({super.key});
  final RegisterStepController registerStepController =
      Get.find<RegisterStepController>();
  final OTPController otpController = Get.find<OTPController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24,
      children: [
        Row(
          spacing: 24,
          children: [
            GestureDetector(
              onTap: registerStepController.prevStep,
              child: Icon(Icons.arrow_back_ios_new, color: AppColors.darkBlue),
            ),
            const Text(
              "Xác thực OTP",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBlue,
              ),
            ),
          ],
        ),

        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Vui lòng nhập mã OTP gồm 6 chữ số đã được gửi đến ",
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 16,
                  height: 2,
                ),
              ),
              TextSpan(
                text: registerStepController.phoneNumberController.text,
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            OtpInput(),

            ErrorText(otpController.errorMessage),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Chưa nhận được OTP?",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                Obx(
                  () => TextButton(
                    onPressed: otpController.canResend.value
                        ? () {
                            otpController.resendOtp();
                          }
                        : null,

                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      otpController.canResend.value
                          ? " Gửi lại"
                          : " Gửi lại (${otpController.secondsLeft.value}s)",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: otpController.canResend.value
                            ? AppColors.darkBlue
                            : AppColors.inactive,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
