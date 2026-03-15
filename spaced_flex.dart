import 'package:flutter/material.dart';

class SpacedFlex extends StatelessWidget {
  final double space;
  final List<Widget> children;
  final Axis direction; // Determines if it acts like a Row or Column
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const SpacedFlex({
    super.key,
    required this.space,
    required this.children,
    required this.direction, // You must specify Axis.horizontal or Axis.vertical
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: children.fold<List<Widget>>([], (list, widget) {
        if (list.isEmpty) return [widget];
        
        // The Magic: dynamically choose width or height based on the axis
        final Widget spacer = direction == Axis.vertical
            ? SizedBox(height: space)
            : SizedBox(width: space);

        return [...list, spacer, widget];
      }),
    );
  }
}