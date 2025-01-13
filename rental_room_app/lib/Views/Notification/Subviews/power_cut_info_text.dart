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
      color: Color(0xFF50C878),
      fontSize: 14,
    ),
    this.valueStyle = const TextStyle(
      color: Color(0xFF50C878),
      fontSize: 14,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: label, style: labelStyle),
            TextSpan(text: value, style: valueStyle),
          ],
        ),
      ),
    );
  }
}
