import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../config/theme_config.dart';
import '../../models/waste_report_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../services/camera_service.dart';
import '../../services/gps_service.dart';
import '../../utils/validators.dart';
import '../../widgets/gps_indicator.dart';
import '../../widgets/photo_picker_widget.dart';
import 'report_history_screen.dart';

class WasteReportScreen extends StatefulWidget {
  const WasteReportScreen({super.key});

  @override
  State<WasteReportScreen> createState() => _WasteReportScreenState();
}

class _WasteReportScreenState extends State<WasteReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wardController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();

  WasteCategory _category = WasteCategory.mixed;
  Position? _position;
  File? _photo;

  @override
  void initState() {
    super.initState();
    final profile = context.read<WBISAuthProvider>().profile;
    if (profile != null) {
      _wardController.text = profile.wardName;
      _cityController.text = profile.city;
    }
    _loadPosition();
  }

  Future<void> _loadPosition() async {
    final position = await GPSService.currentPosition();
    if (mounted) setState(() => _position = position);
  }

  Future<void> _pickPhoto() async {
    final photo = await CameraService.takePhoto();
    if (photo != null && mounted) setState(() => _photo = photo);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for GPS to load.')),
      );
      return;
    }

    final user = context.read<WBISAuthProvider>().user;
    if (user == null) return;

    try {
      await context.read<ReportProvider>().submitReport(
            userId: user.uid,
            category: _category,
            description: _descriptionController.text.trim(),
            wardName: _wardController.text.trim(),
            city: _cityController.text.trim(),
            position: _position!,
            photo: _photo,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted.'),
          backgroundColor: WBISTheme.accentGreen,
        ),
      );
      _descriptionController.clear();
      setState(() => _photo = null);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportHistoryScreen()),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GPSIndicator(position: _position),
            const SizedBox(height: 16),
            TextFormField(
              controller: _wardController,
              decoration: const InputDecoration(
                labelText: 'Ward Name',
                prefixIcon: Icon(Icons.location_city),
              ),
              validator: (value) => Validators.required(value, 'Ward name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                prefixIcon: Icon(Icons.map_outlined),
              ),
              validator: (value) => Validators.required(value, 'City'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<WasteCategory>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Waste Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: WasteCategory.values
                  .where((category) => category != WasteCategory.unknown)
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.notes_outlined),
              ),
              validator: (value) => Validators.required(value, 'Description'),
            ),
            const SizedBox(height: 16),
            PhotoPickerWidget(
              image: _photo,
              onPick: _pickPhoto,
              progress: provider.uploadProgress,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: provider.submitting ? null : _submit,
              icon: provider.submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(provider.submitting ? 'Submitting...' : 'Submit Report'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
