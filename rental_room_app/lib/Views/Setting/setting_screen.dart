import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_room_app/Contract/Setting/setting_screen_contract.dart';
import 'package:rental_room_app/Presenter/Setting/setting_screen_presenter.dart';
import 'package:rental_room_app/Services/shared_preferences_contract.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Models/User/user_repo.dart';
import 'package:rental_room_app/Services/shared_preferences_presenter.dart';
import 'package:rental_room_app/Views/YourRoom/detail_room_screen.dart';
import 'package:rental_room_app/config/asset_helper.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    implements SharedPreferencesContract, SettingScreenContract {
  SharedPreferencesPresenter? _preferencesPresenter;
  late SettingScreenPresenter _settingScreenPresenter;
  final UserRepository _userRepository = UserRepositoryIml();
  int _selectedIndex = 3;
  String _userName = "nguyen van a";
  String _email = "nguyenvana@gmail.com";
  bool _isOwner = true;
  String _userAvatarUrl = "";

  late String _rentalID;
  late Room _yourRoom;

  @override
  void initState() {
    super.initState();
    _settingScreenPresenter = SettingScreenPresenter(this);
    _preferencesPresenter = SharedPreferencesPresenter(this);
    _preferencesPresenter?.getUserInfoFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette.primaryColor,
        title: Text('SETTING',
            style: TextStyles.slo.bold.copyWith(
              shadows: [
                const Shadow(
                  color: Colors.black12,
                  offset: Offset(3, 6),
                  blurRadius: 6,
                )
              ],
            )),
        centerTitle: true,
        toolbarHeight: kToolbarHeight * 1.5,
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Gap(15),
            Container(
              alignment: Alignment.center,
              child: Container(
                height: 132,
                width: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: _userAvatarUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(_userAvatarUrl),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage(AssetHelper.avatar),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const Gap(10),
            Text(
              _userName,
              style: TextStyles.title,
            ),
            const Gap(5),
            Text(
              _email,
              style: TextStyles.descriptionRoom.copyWith(
                fontSize: 16,
              ),
            ),
            const Gap(50),
            GestureDetector(
              onTap: () {
                GoRouter.of(context).go('/setting/edit_profile');
              },
              child: Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: const Icon(
                      FontAwesomeIcons.user,
                      color: ColorPalette.primaryColor,
                      size: 20,
                    ),
                  ),
                  Text(
                    'Edit Profile',
                    style: TextStyles.descriptionRoom.copyWith(
                      color: ColorPalette.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: const Icon(
                      FontAwesomeIcons.language,
                      color: ColorPalette.primaryColor,
                      size: 20,
                    ),
                  ),
                  Text(
                    'Change Language',
                    style: TextStyles.descriptionRoom.copyWith(
                      color: ColorPalette.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            GestureDetector(
              onTap: () {
                GoRouter.of(context).go('/setting/notification');
              },
              child: Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.add_alert_rounded,
                      color: ColorPalette.primaryColor,
                      size: 25,
                    ),
                  ),
                  Text(
                    'Notification Setting',
                    style: TextStyles.descriptionRoom.copyWith(
                      color: ColorPalette.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            GestureDetector(
              onTap: () {
                _settingScreenPresenter.launchEmailApp();
              },
              child: Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: const Icon(
                      FontAwesomeIcons.solidCircleQuestion,
                      color: ColorPalette.primaryColor,
                      size: 20,
                    ),
                  ),
                  Text(
                    'Help Center',
                    style: TextStyles.descriptionRoom.copyWith(
                      color: ColorPalette.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyles.descriptionRoom.copyWith(
                              color: ColorPalette.grayText,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              await _userRepository.signOut();
                              Navigator.of(dialogContext).pop();
                              GoRouter.of(context).go('/log_in');
                            } catch (e) {
                              print("Đăng xuất thất bại: $e");
                            }
                          },
                          child: Text(
                            'Confirm',
                            style: TextStyles.descriptionRoom.copyWith(
                              color: ColorPalette.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: const Icon(
                      FontAwesomeIcons.signOut,
                      color: ColorPalette.primaryColor,
                      size: 20,
                    ),
                  ),
                  Text(
                    'Sign Out',
                    style: TextStyles.descriptionRoom.copyWith(
                      color: ColorPalette.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
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
      _userName = userName ?? "nguyen van a";
      _email = email ?? "nguyenvana@gmail.com ";
      _isOwner = isOwner ?? true;
      _userAvatarUrl = userAvatarUrl ?? "";
      _settingScreenPresenter.loadRoomInfo(rentalId ?? "");
      _rentalID = rentalId ?? "";
    });
  }

  @override
  void onLaunchEmailFailed() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Lỗi'),
            content: const Text('Thiết bị của bạn không có ứng dụng email!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OKE'),
              )
            ],
          );
        });
  }

  @override
  void onUpdateRoom(Room room) {
    _yourRoom = room;
  }
}
