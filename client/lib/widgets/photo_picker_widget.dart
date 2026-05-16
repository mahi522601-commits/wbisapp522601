import 'dart:io';
import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class PhotoPickerWidget extends StatelessWidget {
  final File? image;
  final VoidCallback onPick;
  final double progress;

  const PhotoPickerWidget({
    super.key,
    this.image,
    required this.onPick,
    this.progress = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: 148,
        decoration: BoxDecoration(
          color: WBISTheme.lightGreen,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: WBISTheme.accentGreen.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(image!, fit: BoxFit.cover),
                    if (progress > 0 && progress < 1)
                      Container(
                        color: Colors.black38,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    color: WBISTheme.primaryGreen,
                    size: 36,
                  ),
                  SizedBox(height: 8),
                  Text('Tap to take photo evidence'),
                ],
              ),
      ),
    );
  }
}
