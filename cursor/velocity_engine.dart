import 'package:flutter/material.dart';

class VelocityEngine {
  static const int _sampleSize = 5;
  static const double _maxVelocity = 1500.0; // px/s threshold for H = 1.0

  final List<double> _samples = [];
  Offset? _lastPosition;
  DateTime? _lastTime;

  /// Returns Heat Index H ∈ [0.0, 1.0]
  double update(Offset current, DateTime now) {
    if (_lastPosition == null || _lastTime == null) {
      _lastPosition = current;
      _lastTime = now;
      return 0.0;
    }

    final dt = now.difference(_lastTime!).inMilliseconds / 1000.0;
    if (dt == 0) return _currentHeat();

    final distance = (current - _lastPosition!).distance;
    final velocity = distance / dt;

    _samples.add(velocity);
    if (_samples.length > _sampleSize) _samples.removeAt(0);

    _lastPosition = current;
    _lastTime = now;

    return _currentHeat();
  }

  double _currentHeat() {
    if (_samples.isEmpty) return 0.0;
    final avg = _samples.reduce((a, b) => a + b) / _samples.length;
    return (avg / _maxVelocity).clamp(0.0, 1.0);
  }

  void reset() {
    _samples.clear();
    _lastPosition = null;
    _lastTime = null;
  }
}
