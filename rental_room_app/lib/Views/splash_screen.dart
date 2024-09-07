import 'package:flutter/material.dart';
import 'package:rental_room_app/config/asset_helper.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = 'splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  // ignore: non_constant_identifier_names

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: size.height * 1 / 2,
          color: ColorPalette.primaryColor,
        ),
        Container(
          alignment: Alignment.center,
          color: ColorPalette.primaryColor.withOpacity(0.5),
          child: Container(
            height: size.width * 4 / 9,
            width: size.width * 4 / 9,
            decoration: BoxDecoration(
              color: ColorPalette.primaryColor,
              borderRadius: BorderRadius.circular(size.width * 4 / 9),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Image.asset(
            AssetHelper.logo1,
            width: size.width * 2 / 7,
            height: size.width * 2 / 7,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(bottom: size.height * 1 / 2 - size.width * 2 / 7),
          child: Text(
            'Like House',
            style: TextStyles.slo.copyWith(shadows: [
              const BoxShadow(
                  color: Colors.black26, offset: Offset(0, 4), blurRadius: 6),
            ]),
          ),
        ),
      ],
    ));
  }
}
