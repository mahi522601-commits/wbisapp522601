import 'package:flutter/material.dart';
import 'validation_screen.dart';

class WorkerHomeScreen extends StatelessWidget {
  const WorkerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Worker Console')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Validation Queue',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 8),
                    Text('Review household submissions and confirm waste status.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ValidationScreen()),
              ),
              icon: const Icon(Icons.fact_check),
              label: const Text('Open Validation Queue'),
            ),
          ],
        ),
      ),
    );
  }
}
