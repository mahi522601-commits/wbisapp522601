import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/camera_service.dart';
import '../../widgets/photo_picker_widget.dart';

class PhotoUploadScreen extends StatefulWidget {
  final ValueChanged<File> onSelected;

  const PhotoUploadScreen({super.key, required this.onSelected});

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  File? _photo;

  Future<void> _pick() async {
    final photo = await CameraService.takePhoto();
    if (photo == null) return;
    setState(() => _photo = photo);
    widget.onSelected(photo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Evidence')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: PhotoPickerWidget(image: _photo, onPick: _pick),
      ),
    );
  }
}
