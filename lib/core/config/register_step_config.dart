import 'package:flutter/material.dart';

class RegisterStepConfig {
  final Widget page;
  final String? label;
  final bool? haveBackToPrev;
  final bool showHeader;

  const RegisterStepConfig({
    required this.page,
    this.label,
    this.showHeader = true,
    this.haveBackToPrev = true,
  });
}
