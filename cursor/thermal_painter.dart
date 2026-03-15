import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'path_point.dart';

class ThermalPainter extends CustomPainter {
  final List<PathPoint> points;
  final DateTime now;
  final int ttlMs;

  ThermalPainter({
    required this.points,
    required this.now,
    this.ttlMs = 450, // Short, snappy TTL for a lightweight feel
  });

  // A highly satisfying "Premium Fire" gradient.
  // Instead of using Opacity (which looks muddy when overlapping), 
  // we fade the tail directly into your dark app background!
  //change these colors to customize the gradient to your liking!
  Color _getSatisfyingColor(double t) {
    const bg = Color(0xFF121212); // Veriscan Dark Background
    const cherryRed = Color(0xFF8B002B); // Deep, rich red at the very tip
    const fieryOrange = Color(0xFFFF4500); // Vibrant orange body
    const premiumGold = Color(0xFFFFD700); // Gold neck
    const pureWhite = Color(0xFFFFFFFF); // Blinding white core at the cursor

    if (t <= 0.25) return Color.lerp(bg, cherryRed, t * 4)!;
    if (t <= 0.50) return Color.lerp(cherryRed, fieryOrange, (t - 0.25) * 4)!;
    if (t <= 0.75) return Color.lerp(fieryOrange, premiumGold, (t - 0.50) * 4)!;
    return Color.lerp(premiumGold, pureWhite, (t - 0.75) * 4)!;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 3) return;

    // 1. Create a flawlessly smooth mathematical Bezier curve through all points
    final path = Path();
    path.moveTo(points[0].position.dx, points[0].position.dy);

    for (int i = 1; i < points.length - 1; i++) {
      final p0 = points[i].position;
      final p1 = points[i + 1].position;
      final mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    path.lineTo(points.last.position.dx, points.last.position.dy);

    // 2. Measure the path to draw perfect circles along it
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final totalLength = metric.length;

    if (totalLength == 0) return;

    // 3. Stamp overlapping circles to create the exact "宽头窄尾" shape
    // Stepping every 2.5 pixels ensures buttery smooth anti-aliasing.
    for (double d = 0; d <= totalLength; d += 2.5) {
      final t = d / totalLength; // 0.0 is the tail tip, 1.0 is the cursor head
      final tangent = metric.getTangentForOffset(d);
      if (tangent == null) continue;

      // 宽头窄尾 MATH: math.pow(t, 2.5) creates a beautiful teardrop/comet shape.
      // It stays thin for the tail, and curves out perfectly wide at the head.
      final radius = 12.0 * math.pow(t, 2.5);
      final color = _getSatisfyingColor(t);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      // Draw the solid core
      canvas.drawCircle(tangent.position, radius, paint);
      
      // Optional: Add a faint outer glow to only the top 30% of the comet (the hottest part)
      if (t > 0.7) {
        final glowPaint = Paint()
          ..color = color.withOpacity(0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
        canvas.drawCircle(tangent.position, radius * 2.0, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(ThermalPainter old) => true;
}