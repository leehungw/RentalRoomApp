import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rental_room_app/config/asset_helper.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/model_button.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});
  static const String routeName = 'no_internet_page';

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetHelper.noInternet,
              width: 325,
              height: 260,
            ),
            const Text(
              'Not Connected',
              style: TextStyles.noInternetTitle,
            ),
            const Gap(12),
            const Text(
              'Ups. You are not connected to internet\nTry again',
              textAlign: TextAlign.center,
              style: TextStyles.noInternetDes,
            ),
            const Gap(30),
            ModelButton(
              onTap: () {},
              name: 'Try Again',
              color: ColorPalette.primaryColor,
              width: 160,
            ),
          ],
        ),
      ),
    );
  }
}
