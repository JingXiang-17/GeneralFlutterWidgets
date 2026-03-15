import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Required for PointerHoverEvent
import 'package:flutter/scheduler.dart'; // Required for Ticker
import 'thermal_painter.dart';
import 'path_point.dart';
import 'velocity_engine.dart'; // Your custom velocity calculation logic

class TfpCursorOverlay extends StatefulWidget {
  final Widget child;
  const TfpCursorOverlay({super.key, required this.child});

  @override
  State<TfpCursorOverlay> createState() => _TfpCursorOverlayState();
}

class _TfpCursorOverlayState extends State<TfpCursorOverlay>
    with SingleTickerProviderStateMixin {
  final List<PathPoint> _points = [];
  final VelocityEngine _engine = VelocityEngine();
  late final Ticker _ticker;

  static const int _maxPoints = 50;
  static const int _ttlMs    = 450;

  @override
  void initState() {
    super.initState();
    // Ticker drives continuous repaints for fade-out even when mouse is idle
    _ticker = createTicker((_) => _purgeAndRefresh())..start();
  }

  void _purgeAndRefresh() {
    final now = DateTime.now();
    setState(() {
      _points.removeWhere(
        (p) => now.difference(p.timestamp).inMilliseconds > _ttlMs,
      );
    });
  }

  void _onHover(PointerHoverEvent event) {
    final now = DateTime.now();
    final h = _engine.update(event.localPosition, now);

    setState(() {
      _points.add(PathPoint(
        position: event.localPosition,
        timestamp: now,
        velocityAtBirth: h,
      ));
      if (_points.length > _maxPoints) _points.removeAt(0);
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      cursor: SystemMouseCursors.basic,
      child: Stack(
        children: [
          widget.child,
          // RepaintBoundary isolates repaints to this layer only
          RepaintBoundary(
            child: IgnorePointer(
              child: CustomPaint(
                painter: ThermalPainter(
                  points: List.unmodifiable(_points),
                  now: DateTime.now(),
                  ttlMs: _ttlMs,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
