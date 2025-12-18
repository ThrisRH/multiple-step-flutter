import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/controller/ocr_controller.dart';
import 'package:test/controller/register_controller.dart';
import 'package:test/core/config/register_step_config.dart';
import 'package:test/core/theme/colors.dart';
import 'package:test/widgets/layout/multiple_form/header.dart';

class RegisterMainLayout extends StatelessWidget {
  final List<RegisterStepConfig> stepsList;
  final RegisterStepController controller;
  const RegisterMainLayout({
    super.key,
    required this.stepsList,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final isLoading = Get.find<OCRScannerController>().isLoading.value;
        final currentStep = stepsList[controller.index.value];

        return Stack(
          children: [
            AbsorbPointer(
              absorbing: isLoading,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  spacing: 24,
                  children: [
                    if (controller.index.value < stepsList.length - 1)
                      LinearProgressIndicator(
                        value: ((controller.index.value + 1) / stepsList.length)
                            .clamp(0.0, 1.0),

                        color: AppColors.primary,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(12),
                      ),

                    // Header
                    AppHeader(
                      label: currentStep.label!,
                      haveBackToPrev: currentStep.haveBackToPrev!,
                      onTap: () {
                        if (currentStep.haveBackToPrev!) {
                          controller.prevStep();
                        }
                      },
                    ),

                    // Body content
                    Expanded(
                      child: PageView(
                        controller: controller.pageController,
                        physics: NeverScrollableScrollPhysics(),
                        children: stepsList.map((e) => e.page).toList(),
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
