import 'package:flutter/material.dart';

class SubFrame extends StatelessWidget {
  final Widget? child;
  const SubFrame({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: (size.width - 100) / 3,
      height: 75,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(9)),
        child: child,
      ),
    );
  }
}
