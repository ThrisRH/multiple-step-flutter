import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabebank/core/theme/colors.dart';

class ErrorText extends StatelessWidget {
  final RxString error;

  const ErrorText(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (error.value.isEmpty || error.value == "") {
        return const SizedBox.shrink();
      }
      return Text(
        error.value,
        style: const TextStyle(color: AppColors.error, fontSize: 14),
      );
    });
  }
}
