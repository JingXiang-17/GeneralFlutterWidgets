import 'package:flutter/material.dart';

class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? desktop;
  final double breakpoint;

  const AdaptiveLayout({
    super.key, 
    required this.mobile, 
    this.desktop, 
    this.breakpoint = 600,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > breakpoint && desktop != null) {
          return desktop!;
        }
        return mobile;
      },
    );
  }
}