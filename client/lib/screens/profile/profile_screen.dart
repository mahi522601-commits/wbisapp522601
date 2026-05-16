import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/helpers.dart';
import '../splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<WBISAuthProvider>();
    final profile = auth.profile;
    final name = profile?.displayName ?? auth.user?.displayName ?? 'WBIS User';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 42,
            child: Text(
              WBISHelpers.initials(name),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Name'),
                  subtitle: Text(name),
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(auth.user?.email ?? profile?.email ?? ''),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: const Text('Ward'),
                  subtitle: Text(profile?.wardName ?? ''),
                ),
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Household'),
                  subtitle: Text(profile?.householdId ?? ''),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const SplashScreen()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
