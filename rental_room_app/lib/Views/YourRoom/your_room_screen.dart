import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_room_app/Services/shared_preferences_contract.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class YourRoomScreen extends StatefulWidget {
  const YourRoomScreen({super.key});
  static const String routeName = "detail_room";

  @override
  State<YourRoomScreen> createState() => _YourRoomScreenState();
}

class _YourRoomScreenState extends State<YourRoomScreen>
    implements SharedPreferencesContract {
  int _selectedIndex = 1;

  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette.backgroundColor,
        title: Text('YOUR ROOM',
            style: TextStyles.slo.bold.copyWith(
              color: ColorPalette.primaryColor,
              shadows: [
                const Shadow(
                  color: Colors.black12,
                  offset: Offset(3, 3),
                  blurRadius: 6,
                )
              ],
            )),
        centerTitle: true,
        toolbarHeight: kToolbarHeight * 1.5,
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorPalette.backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ColorPalette.primaryColor,
                  width: 2,
                ),
              ),
              child: const Text(
                  'You need to rental a room to use this function!!!'),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: ColorPalette.backgroundColor,
        currentIndex: _selectedIndex,
        onTap: (id) {
          setState(() {
            _selectedIndex = id;
          });
          switch (id) {
            case 0:
              GoRouter.of(context).go('/home');
              break;
            case 1:
              GoRouter.of(context).go('/your_room');
              break;
            case 2:
              GoRouter.of(context).go('/notification_list');
              break;
            case 3:
              GoRouter.of(context).go('/setting');
              break;
            default:
              break;
          }
        },
        items: [
          SalomonBottomBarItem(
              icon: const Icon(
                FontAwesomeIcons.house,
                color: ColorPalette.primaryColor,
                size: 20,
              ),
              title: const Text(
                'Home',
                style: TextStyles.bottomBar,
              )),
          if (!_isOwner)
            SalomonBottomBarItem(
                icon: const Icon(
                  FontAwesomeIcons.doorOpen,
                  color: ColorPalette.primaryColor,
                  size: 20,
                ),
                title: const Text(
                  'Your Room',
                  style: TextStyles.bottomBar,
                )),
          if (_isOwner)
            SalomonBottomBarItem(
                icon: const Icon(
                  FontAwesomeIcons.chartLine,
                  color: ColorPalette.primaryColor,
                  size: 20,
                ),
                title: const Text(
                  'Statistic',
                  style: TextStyles.bottomBar,
                )),
          SalomonBottomBarItem(
              icon: const Icon(
                FontAwesomeIcons.bell,
                color: ColorPalette.primaryColor,
                size: 20,
              ),
              title: const Text(
                'Notification',
                style: TextStyles.bottomBar,
              )),
          SalomonBottomBarItem(
              icon: const Icon(
                FontAwesomeIcons.gear,
                color: ColorPalette.primaryColor,
                size: 20,
              ),
              title: const Text(
                'Setting',
                style: TextStyles.bottomBar,
              )),
        ],
      ),
    );
  }

  @override
  void updateView(String? userName, bool? isOwner, String? userAvatarUrl,
      String? email, String? rentalId) {
    setState(() {
      _isOwner = isOwner ?? false;
    });
  }
}
