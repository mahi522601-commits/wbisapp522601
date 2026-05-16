import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../config/theme_config.dart';

class GPSIndicator extends StatelessWidget {
  final Position? position;

  const GPSIndicator({super.key, this.position});

  @override
  Widget build(BuildContext context) {
    final ready = position != null;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ready ? WBISTheme.lightGreen : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.gps_fixed,
            color: ready ? WBISTheme.primaryGreen : Colors.orange,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              ready
                  ? 'GPS: ${position!.latitude.toStringAsFixed(5)}, ${position!.longitude.toStringAsFixed(5)}'
                  : 'Fetching GPS location...',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
