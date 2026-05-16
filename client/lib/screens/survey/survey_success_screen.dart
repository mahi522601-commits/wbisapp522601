import 'package:flutter/material.dart';
import '../../config/theme_config.dart';
import '../../widgets/custom_button.dart';

class SurveySuccessScreen extends StatelessWidget {
  const SurveySuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: WBISTheme.accentGreen,
                size: 96,
              ),
              const SizedBox(height: 18),
              const Text(
                'Survey submitted',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your report is now available to workers and admins for validation.',
                textAlign: TextAlign.center,
                style: TextStyle(color: WBISTheme.textGray),
              ),
              const SizedBox(height: 28),
              CustomButton(
                label: 'Back to dashboard',
                icon: Icons.dashboard,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
