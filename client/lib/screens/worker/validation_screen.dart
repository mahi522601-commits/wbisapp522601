import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/survey_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../widgets/waste_status_chip.dart';

class ValidationScreen extends StatelessWidget {
  const ValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workerId = context.watch<WBISAuthProvider>().user?.uid ?? 'worker';
    return Scaffold(
      appBar: AppBar(title: const Text('Validate Surveys')),
      body: StreamBuilder<List<SurveyModel>>(
        stream: FirestoreService.getAllSurveys(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final pending = snap.data!.where((survey) => !survey.isValidated).toList();
          if (pending.isEmpty) {
            return const Center(child: Text('No pending surveys.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: pending.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final survey = pending[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (survey.photoUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: survey.photoUrl!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        '${survey.wardName}, ${survey.city}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      WasteStatusChip(status: survey.status),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: WasteStatus.values.map((status) {
                          return ActionChip(
                            label: Text(status.label),
                            onPressed: () => FirestoreService.validateSurvey(
                              survey.id,
                              workerId,
                              status,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
