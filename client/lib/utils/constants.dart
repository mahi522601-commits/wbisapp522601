import 'package:flutter/material.dart';

class WBISConstants {
  static const wasteStatuses = ['proper', 'minorMixing', 'mixedWaste', 'hazardous'];
  static const cities = ['Bengaluru', 'Mumbai', 'Delhi', 'Pune', 'Chennai'];
  static const defaultPadding = 20.0;
}

const Map<String, Color> wasteStatusColors = {
  'GREEN': Colors.green,
  'YELLOW': Colors.amber,
  'RED': Colors.red,
  'BLACK': Colors.black87,
};
