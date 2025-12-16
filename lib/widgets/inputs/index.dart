import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test/core/theme/colors.dart';

abstract class BaseInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool readOnly;
  final bool isDisabled;

  const BaseInput({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
    required this.keyboardType,
    required this.readOnly,
    required this.isDisabled,
    this.inputFormatters,
    this.controller,
    this.maxLength,
  });

  Widget buildInputField(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 24 / 14,
                color: AppColors.labelGrey,
              ),
            ),
          ),

        buildInputField(context),
      ],
    );
  }
}

// Normal Button
class NormalInput extends BaseInput {
  const NormalInput({
    super.key,
    required super.label,
    required super.hint,
    required super.onChanged,

    super.keyboardType = TextInputType.text,
    super.readOnly = false,
    super.isDisabled = false,
    super.controller,
    super.maxLength,
    super.inputFormatters,
  });

  @override
  Widget buildInputField(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(width: 1, color: AppColors.border),
        color: isDisabled ? AppColors.inputDisable : Colors.transparent,
      ),

      child: TextField(
        inputFormatters: inputFormatters,
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(fontSize: 14, height: 24 / 20),
        readOnly: isDisabled,
        maxLength: maxLength,

        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            height: 24 / 14,
            color: AppColors.inputPlaceHolder,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

class PasswordController extends GetxController {
  final obscure = true.obs;

  void toggleObscure() => obscure.value = !obscure.value;
}

// Password input
class PasswordInput extends BaseInput {
  PasswordInput({
    super.key,
    required super.label,
    required super.hint,
    required super.onChanged,

    super.keyboardType = TextInputType.text,
    super.readOnly = false,
    super.isDisabled = false,
    super.controller,
  });

  final PasswordController passController = Get.put(
    PasswordController(),
    tag: UniqueKey().toString(),
  );

  @override
  Widget buildInputField(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(width: 1, color: AppColors.border),
      ),

      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Obx(() {
              return TextField(
                controller: controller,
                onChanged: onChanged,
                keyboardType: TextInputType.visiblePassword,
                obscureText: passController.obscure.value,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 24 / 20,
                    color: AppColors.inputPlaceHolder,
                  ),
                ),
              );
            }),
          ),

          GestureDetector(
            onTap: () => passController.toggleObscure(),
            child: Icon(Icons.remove_red_eye_rounded),
          ),
        ],
      ),
    );
  }
}
