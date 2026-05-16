import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/theme_config.dart';
import '../../models/survey_model.dart';
import '../../models/user_model.dart';
import '../../models/waste_report_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../splash_screen.dart';
import 'admin_analytics_tab.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  Future<void> _exportData(String type, List<List<dynamic>> rows) async {
    // Manual CSV generation to bypass package versioning issues
    String csv = rows.map((row) {
      return row.map((item) {
        String stringItem = item.toString().replaceAll('"', '""');
        return '"$stringItem"';
      }).join(',');
    }).join('\n');
    
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${type}_export_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);
    await file.writeAsString(csv);
    await Share.shareXFiles([XFile(path)], text: '$type Data Export');
  }

  void _deleteUser(String id) {
    FirestoreService.deleteUser(id);
  }

  void _deleteSurvey(String id) {
    FirestoreService.deleteSurvey(id);
  }

  void _deleteReport(String id) {
    FirestoreService.deleteReport(id);
  }

  void _showSurveyDetails(SurveyModel survey) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Survey Details'),
        content: _DialogContent(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (survey.photoUrl != null && survey.photoUrl!.isNotEmpty) ...[
                  _EvidenceImage(url: survey.photoUrl!),
                  const SizedBox(height: 16),
                ],
                Text('Status: ${survey.status.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Location: ${survey.wardName}, ${survey.city}'),
                Text('Coordinates: ${survey.latitude}, ${survey.longitude}'),
                Text('Household ID: ${survey.householdId}'),
                Text('Score Impact: ${survey.behaviourScore}'),
                Text('Created At: ${survey.createdAt.toString()}'),
                if (survey.workerNotes != null) Text('Notes: ${survey.workerNotes}'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close'))
        ],
      ),
    );
  }

  void _showReportDetails(WasteReportModel report) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Report Details'),
        content: _DialogContent(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (report.photoUrl != null && report.photoUrl!.isNotEmpty) ...[
                  _EvidenceImage(url: report.photoUrl!),
                  const SizedBox(height: 16),
                ],
                Text('Category: ${report.category.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Status: ${report.status.name}'),
                Text('Description: ${report.description}'),
                Text('Location: ${report.wardName}, ${report.city}'),
                Text('Coordinates: ${report.latitude}, ${report.longitude}'),
                Text('Created At: ${report.createdAt.toString()}'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: WBISTheme.primaryGreen,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await context.read<WBISAuthProvider>().signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SplashScreen()),
                    (route) => false,
                  );
                }
              },
            )
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Surveys'),
              Tab(text: 'Reports'),
              Tab(text: 'Analytics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUsersTab(),
            _buildSurveysTab(),
            _buildReportsTab(),
            const AdminAnalyticsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return StreamBuilder<List<UserModel>>(
      stream: FirestoreService.getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final users = snapshot.data!;
        
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            heroTag: 'users_csv',
            backgroundColor: WBISTheme.primaryGreen,
            child: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              List<List<dynamic>> rows = [
                ['UID', 'Email', 'Name', 'Phone', 'Role', 'City', 'Ward', 'Created At']
              ];
              for (var u in users) {
                rows.add([u.uid, u.email, u.displayName, u.phone, u.role.name, u.city, u.wardName, u.createdAt.toIso8601String()]);
              }
              _exportData('users', rows);
            },
          ),
          body: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text('${user.displayName} (${user.role.name})'),
                subtitle: Text(user.email),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(user.uid),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSurveysTab() {
    return StreamBuilder<List<SurveyModel>>(
      stream: FirestoreService.getAllSurveys(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final surveys = snapshot.data!;
        
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            heroTag: 'surveys_csv',
            backgroundColor: WBISTheme.primaryGreen,
            child: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              List<List<dynamic>> rows = [
                ['ID', 'User ID', 'City', 'Ward', 'Status', 'Score', 'Validated', 'Created At']
              ];
              for (var s in surveys) {
                rows.add([s.id, s.userId, s.city, s.wardName, s.status.name, s.behaviourScore, s.isValidated, s.createdAt.toIso8601String()]);
              }
              _exportData('surveys', rows);
            },
          ),
          body: ListView.builder(
            itemCount: surveys.length,
            itemBuilder: (context, index) {
              final survey = surveys[index];
              return ListTile(
                title: Text('Survey: ${survey.status.name}'),
                subtitle: Text('${survey.city} - ${survey.wardName}'),
                onTap: () => _showSurveyDetails(survey),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.blue),
                      onPressed: () => _showSurveyDetails(survey),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteSurvey(survey.id),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildReportsTab() {
    return StreamBuilder<List<WasteReportModel>>(
      stream: FirestoreService.getAllReports(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final reports = snapshot.data!;
        
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            heroTag: 'reports_csv',
            backgroundColor: WBISTheme.primaryGreen,
            child: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              List<List<dynamic>> rows = [
                ['ID', 'User ID', 'Category', 'Status', 'City', 'Ward', 'Description', 'Created At']
              ];
              for (var r in reports) {
                rows.add([r.id, r.userId, r.category.name, r.status.name, r.city, r.wardName, r.description, r.createdAt.toIso8601String()]);
              }
              _exportData('reports', rows);
            },
          ),
          body: ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return ListTile(
                title: Text('Report: ${report.category.name}'),
                subtitle: Text('${report.status.name} - ${report.city}'),
                onTap: () => _showReportDetails(report),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.blue),
                      onPressed: () => _showReportDetails(report),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteReport(report.id),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _DialogContent extends StatelessWidget {
  final Widget child;

  const _DialogContent({required this.child});

  @override
  Widget build(BuildContext context) {
    final width = math.min(MediaQuery.sizeOf(context).width * 0.82, 420.0);
    return SizedBox(width: width, child: child);
  }
}

class _EvidenceImage extends StatelessWidget {
  final String url;

  const _EvidenceImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Image could not be loaded',
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
