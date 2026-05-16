import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/waste_report_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../utils/helpers.dart';

class ReportHistoryScreen extends StatelessWidget {
  const ReportHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<WBISAuthProvider>().user;
    return Scaffold(
      appBar: AppBar(title: const Text('Report History')),
      body: StreamBuilder<List<WasteReportModel>>(
        stream: user == null
            ? const Stream.empty()
            : FirestoreService.getUserReports(user.uid),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final reports = snap.data!;
          if (reports.isEmpty) {
            return const Center(child: Text('No reports submitted yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: reports.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.delete_outline)),
                  title: Text(report.description),
                  subtitle: Text(
                    '${report.category.name} · ${WBISHelpers.formatDate(report.createdAt)}',
                  ),
                  trailing: Text(report.status.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
