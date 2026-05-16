import 'package:flutter/material.dart';
import '../config/theme_config.dart';
import '../widgets/custom_button.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                width: 82,
                height: 82,
                decoration: const BoxDecoration(
                  color: WBISTheme.lightGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.eco,
                  color: WBISTheme.primaryGreen,
                  size: 44,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Build cleaner neighbourhoods with visible waste behaviour.',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.12,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Submit waste surveys, upload evidence, validate households, and track green scores across wards.',
                style: TextStyle(
                  color: WBISTheme.textGray,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              CustomButton(
                label: 'Create account',
                icon: Icons.person_add_alt_1,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'Sign in',
                icon: Icons.login,
                outlined: true,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
