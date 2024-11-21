import 'package:flutter/material.dart';

class PowerCutInfoText extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  const PowerCutInfoText({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: 14,
    ),
    this.valueStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: label, style: labelStyle),
          TextSpan(text: value, style: valueStyle),
        ],
      ),
    );
  }
}
