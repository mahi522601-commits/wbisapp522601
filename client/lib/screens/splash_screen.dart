import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme_config.dart';
import '../providers/auth_provider.dart';
import 'admin/admin_home_screen.dart';
import 'home/home_screen.dart';
import 'onboarding_screen.dart';
import '../models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<WBISAuthProvider>();
    if (_ready && !auth.loading && auth.isProfileLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              if (!auth.isSignedIn) return const OnboardingScreen();
              if (auth.profile?.role == UserRole.admin) return const AdminHomeScreen();
              return const HomeScreen();
            },
          ),
        );
      });
    }

    return const Scaffold(
      backgroundColor: WBISTheme.primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.recycling, color: Colors.white, size: 76),
            SizedBox(height: 18),
            Text(
              'WBIS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Waste Behaviour Intelligence System',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
