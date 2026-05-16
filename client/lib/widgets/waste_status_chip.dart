import 'package:flutter/material.dart';
import '../models/survey_model.dart';
import '../config/theme_config.dart';

class WasteStatusChip extends StatelessWidget {
  final WasteStatus status;

  const WasteStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      WasteStatus.proper => Colors.green,
      WasteStatus.minorMixing => Colors.amber,
      WasteStatus.mixedWaste => Colors.red,
      WasteStatus.hazardous => WBISTheme.hazardBlack,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.28)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
