import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JuicyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const JuicyButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<JuicyButton> createState() => _JuicyButtonState();
}

class _JuicyButtonState extends State<JuicyButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // 1. Determine scale based on state
    final double scale = _isPressed 
        ? 0.95 // Slightly deeper squish
        : (_isHovered ? 1.04 : 1.0); 

    return MouseRegion(
      cursor: SystemMouseCursors.click, // Shows pointer on Web/Desktop
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          HapticFeedback.lightImpact();
          setState(() => _isPressed = true);
        },
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () async {
          // The "Juice" delay: ensures the animation completes
          await Future.delayed(const Duration(milliseconds: 100));
          widget.onTap();
        },
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutBack, // Gives that nice "spring" bounce
          child: widget.child,
        ),
      ),
    );
  }
}