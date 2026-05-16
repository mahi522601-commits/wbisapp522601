import 'package:flutter/material.dart';
import '../../config/theme_config.dart';
import '../report/waste_report_screen.dart';
import '../score/behaviour_score_screen.dart';
import '../survey/survey_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(onOpenTab: (index) => setState(() => _selectedIndex = index)),
      const SurveyScreen(),
      const WasteReportScreen(),
      const BehaviourScoreScreen(),
    ];

    return Scaffold(
      backgroundColor: WBISTheme.backgroundWhite,
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: WBISTheme.lightGreen,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: WBISTheme.primaryGreen),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: WBISTheme.primaryGreen),
            label: 'Survey',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_camera_outlined),
            selectedIcon: Icon(Icons.photo_camera, color: WBISTheme.primaryGreen),
            label: 'Report',
          ),
          NavigationDestination(
            icon: Icon(Icons.stars_outlined),
            selectedIcon: Icon(Icons.stars, color: WBISTheme.primaryGreen),
            label: 'Score',
          ),
        ],
      ),
    );
  }
}
