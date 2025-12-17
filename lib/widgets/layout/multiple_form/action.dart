import 'package:flutter/material.dart';
import 'package:test/widgets/buttons/index.dart';

class ActionWrapper extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final String label;
  final bool canNext;

  const ActionWrapper({
    super.key,
    required this.onBack,
    required this.onNext,
    required this.canNext,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          flex: 1,
          child: AppBorderButton(onTap: onBack, label: "Quay lại"),
        ),
        Expanded(
          flex: 2,
          child: AppButton(disabled: !canNext, onTap: onNext, label: label),
        ),
      ],
    );
  }
}
