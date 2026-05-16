import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/theme_config.dart';
import '../../models/survey_model.dart';
import '../../models/waste_report_model.dart';
import '../../services/firestore_service.dart';

class AdminAnalyticsTab extends StatelessWidget {
  const AdminAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Reports by Category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: StreamBuilder<List<WasteReportModel>>(
            stream: FirestoreService.getAllReports(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              
              final reports = snapshot.data!;
              if (reports.isEmpty) return const Center(child: Text('No report data available'));

              int dry = reports.where((r) => r.category == WasteCategory.dry).length;
              int wet = reports.where((r) => r.category == WasteCategory.wet).length;
              int hazardous = reports.where((r) => r.category == WasteCategory.hazardous).length;
              int mixed = reports.where((r) => r.category == WasteCategory.mixed).length;

              return PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(value: dry.toDouble(), title: 'Dry ($dry)', color: Colors.blue, radius: 60),
                    PieChartSectionData(value: wet.toDouble(), title: 'Wet ($wet)', color: Colors.green, radius: 60),
                    PieChartSectionData(value: hazardous.toDouble(), title: 'Hazardous ($hazardous)', color: Colors.red, radius: 60),
                    PieChartSectionData(value: mixed.toDouble(), title: 'Mixed ($mixed)', color: Colors.orange, radius: 60),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
        const Text('Surveys by Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: StreamBuilder<List<SurveyModel>>(
            stream: FirestoreService.getAllSurveys(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              
              final surveys = snapshot.data!;
              if (surveys.isEmpty) return const Center(child: Text('No survey data available'));

              int proper = surveys.where((s) => s.status == WasteStatus.proper).length;
              int minor = surveys.where((s) => s.status == WasteStatus.minorMixing).length;
              int mixedWaste = surveys.where((s) => s.status == WasteStatus.mixedWaste).length;
              int hazardousWaste = surveys.where((s) => s.status == WasteStatus.hazardous).length;

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (surveys.length + 5).toDouble(),
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0: return const Text('Proper', style: TextStyle(fontSize: 10));
                            case 1: return const Text('Minor', style: TextStyle(fontSize: 10));
                            case 2: return const Text('Mixed', style: TextStyle(fontSize: 10));
                            case 3: return const Text('Hazardous', style: TextStyle(fontSize: 10));
                            default: return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: proper.toDouble(), color: Colors.green, width: 20)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: minor.toDouble(), color: Colors.yellow, width: 20)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: mixedWaste.toDouble(), color: Colors.orange, width: 20)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: hazardousWaste.toDouble(), color: Colors.red, width: 20)]),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
