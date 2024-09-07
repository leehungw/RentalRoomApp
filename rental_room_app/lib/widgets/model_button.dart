import 'package:flutter/material.dart';
import 'package:rental_room_app/themes/text_styles.dart';

class ModelButton extends StatelessWidget {
  final Function() onTap;
  final String name;
  final Color color;
  final double width;
  const ModelButton(
      {super.key,
      required this.onTap,
      required this.name,
      required this.color,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        width: width,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            name,
            style: TextStyles.buttonName,
          ),
        ));
  }
}
