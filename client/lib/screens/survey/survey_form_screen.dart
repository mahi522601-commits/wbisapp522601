import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../config/theme_config.dart';
import '../../models/survey_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/survey_provider.dart';
import '../../services/camera_service.dart';
import '../../services/gps_service.dart';
import '../../utils/validators.dart';
import '../../widgets/gps_indicator.dart';
import '../../widgets/photo_picker_widget.dart';
import 'survey_success_screen.dart';

class SurveyFormScreen extends StatefulWidget {
  const SurveyFormScreen({super.key});

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wardController = TextEditingController();
  final _cityController = TextEditingController();
  final _householdController = TextEditingController();
  final _notesController = TextEditingController();

  WasteStatus _selectedStatus = WasteStatus.proper;
  File? _selectedImage;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _prefillFromProfile();
    _fetchLocation();
  }

  void _prefillFromProfile() {
    final profile = context.read<WBISAuthProvider>().profile;
    if (profile == null) return;
    _wardController.text = profile.wardName;
    _cityController.text = profile.city;
    _householdController.text = profile.householdId;
  }

  Future<void> _fetchLocation() async {
    final position = await GPSService.currentPosition();
    if (mounted) setState(() => _currentPosition = position);
  }

  Future<void> _pickImage() async {
    final image = await CameraService.takePhoto();
    if (image != null && mounted) setState(() => _selectedImage = image);
  }

  Future<void> _submitSurvey() async {
    if (!_formKey.currentState!.validate()) return;
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for GPS to load.')),
      );
      return;
    }

    final user = context.read<WBISAuthProvider>().user;
    if (user == null) return;

    try {
      await context.read<SurveyProvider>().submitSurvey(
            userId: user.uid,
            householdId: _householdController.text.trim(),
            wardName: _wardController.text.trim(),
            city: _cityController.text.trim(),
            status: _selectedStatus,
            position: _currentPosition!,
            notes: _notesController.text.trim(),
            photo: _selectedImage,
          );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SurveySuccessScreen()),
      );
      _resetForm();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _resetForm() {
    _notesController.clear();
    setState(() {
      _selectedImage = null;
      _selectedStatus = WasteStatus.proper;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SurveyProvider>();
    return Scaffold(
      backgroundColor: WBISTheme.backgroundWhite,
      appBar: AppBar(
        title: const Text('Submit Survey'),
        backgroundColor: WBISTheme.backgroundWhite,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GPSIndicator(position: _currentPosition),
            const SizedBox(height: 16),
            _field(_wardController, 'Ward Name', Icons.location_city),
            const SizedBox(height: 12),
            _field(_cityController, 'City', Icons.map),
            const SizedBox(height: 12),
            _field(_householdController, 'Household ID', Icons.home),
            const SizedBox(height: 20),
            const Text(
              'Waste Status',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: WBISTheme.textDark,
              ),
            ),
            const SizedBox(height: 10),
            ..._statusButtons(),
            const SizedBox(height: 20),
            PhotoPickerWidget(
              image: _selectedImage,
              onPick: _pickImage,
              progress: provider.uploadProgress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Additional Notes',
                prefixIcon: Icon(Icons.note_outlined),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: provider.submitting ? null : _submitSurvey,
              icon: provider.submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(provider.submitting ? 'Submitting...' : 'Submit Survey'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _field(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: (value) => Validators.required(value, label),
    );
  }

  List<Widget> _statusButtons() {
    final statuses = [
      (WasteStatus.proper, Colors.green, Icons.check_circle),
      (WasteStatus.minorMixing, Colors.amber, Icons.warning),
      (WasteStatus.mixedWaste, Colors.red, Icons.dangerous),
      (WasteStatus.hazardous, Colors.black, Icons.report_problem),
    ];

    return statuses.map((entry) {
      final status = entry.$1;
      final color = entry.$2;
      final icon = entry.$3;
      final selected = _selectedStatus == status;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () => setState(() => _selectedStatus = status),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: selected ? color.withOpacity(0.15) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? color : Colors.grey.shade200,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    status.label,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: selected ? color : WBISTheme.textGray,
                    ),
                  ),
                ),
                Text(
                  '${status.scoreImpact > 0 ? '+' : ''}${status.scoreImpact} pts',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
