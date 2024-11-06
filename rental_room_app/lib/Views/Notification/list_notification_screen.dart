import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_room_app/Contract/Notification/list_notification_contract.dart';
import 'package:rental_room_app/Presenter/Notification/list_notification_presenter.dart';
import 'package:rental_room_app/Services/shared_preferences_contract.dart';
import 'package:rental_room_app/Models/Receipt/receipt_model.dart';
import 'package:rental_room_app/Models/Receipt/receipt_repo.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Services/shared_preferences_presenter.dart';
import 'package:rental_room_app/Views/Notification/Subviews/list_notification_view.dart';
import 'package:rental_room_app/Views/Notification/Subviews/power_cut_view.dart';
import 'package:rental_room_app/Views/YourRoom/detail_room_screen.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/receipt_item.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class ListNotificationScreen extends StatefulWidget {
  const ListNotificationScreen({super.key});

  @override
  State<ListNotificationScreen> createState() => _ListNotificationScreenState();
}

class _ListNotificationScreenState extends State<ListNotificationScreen>
    implements SharedPreferencesContract, ListNotificationContract {
  SharedPreferencesPresenter? _preferencesPresenter;
  late ListNotificationPresenter _listNotiPresenter;
  int _selectedIndex = 2;
  bool _isOwner = true;

  late String _rentalID;
  late Room _yourRoom;

  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _preferencesPresenter = SharedPreferencesPresenter(this);
    _listNotiPresenter = ListNotificationPresenter(this);
    _preferencesPresenter?.getUserInfoFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 0;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 0
                          ? ColorPalette.primaryColor
                          : ColorPalette.backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Notification',
                      style: TextStyles.title.copyWith(
                        fontSize: 18,
                        color: _selectedIndex == 0
                            ? Colors.white
                            : ColorPalette.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 1; // Show Power Cut Schedule view
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 1
                          ? ColorPalette.primaryColor
                          : ColorPalette.backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Power Cut Schedule',
                      style: TextStyles.title.copyWith(
                        fontSize: 18,
                        color: _selectedIndex == 1
                            ? Colors.white
                            : ColorPalette.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _selectedTab == 0
          ? NotificationView(
              isOwner: _isOwner,
            )
          : const PowerCutScheduleView(),
      bottomNavigationBar: SalomonBottomBar(
          backgroundColor: ColorPalette.backgroundColor,
          currentIndex: _selectedIndex,
          onTap: (id) {
            if (!_isOwner && _rentalID.isNotEmpty) {
            } else {
              setState(() {
                _selectedIndex = id;
              });
            }
            switch (id) {
              case 0:
                GoRouter.of(context).go('/home');
                break;
              case 1:
                if (_isOwner) {
                  GoRouter.of(context).go('/report');
                } else {
                  if (_rentalID.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailRoomScreen(
                          room: _yourRoom,
                        ),
                      ),
                    );
                  } else {
                    GoRouter.of(context).go('/your_room');
                  }
                }
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
          ]),
    );
  }

  @override
  void updateView(String? userName, bool? isOwner, String? userAvatarUrl,
      String? email, String? rentalId) {
    setState(() {
      _isOwner = isOwner ?? true;
      _rentalID = rentalId ?? "";
      _listNotiPresenter.loadRoomInfo(rentalId ?? "");
    });
  }

  @override
  void onUpdateRoom(Room room) {
    _yourRoom = room;
  }
}
