import 'package:flutter/material.dart';
import 'package:rental_room_app/themes/color_palete.dart';

class BorderContainer extends StatelessWidget {
  final Widget? child;
  const BorderContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.only(top: 5),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: ColorPalette.detailBorder.withOpacity(0.1),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: child,
    );
  }
}
