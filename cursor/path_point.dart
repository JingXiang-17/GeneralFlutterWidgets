import 'package:flutter/material.dart';

class PathPoint {
  final Offset position;
  final DateTime timestamp;
  final double velocityAtBirth; // locks in color for this segment

  const PathPoint({
    required this.position,
    required this.timestamp,
    required this.velocityAtBirth,
  });

  double age(DateTime now) =>
      now.difference(timestamp).inMilliseconds.toDouble();
}
