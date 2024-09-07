import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_room_app/Contract/shared_preferences_presenter.dart';
import 'package:rental_room_app/Models/Receipt/receipt_model.dart';
import 'package:rental_room_app/Models/Receipt/receipt_repo.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Models/Room/room_repo.dart';
import 'package:rental_room_app/Presenter/shared_preferences_presenter.dart';
import 'package:rental_room_app/Views/detail_room_screen.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/receipt_item.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListNotificationScreen extends StatefulWidget {
  const ListNotificationScreen({super.key});

  @override
  State<ListNotificationScreen> createState() => _ListNotificationScreenState();
}

class _ListNotificationScreenState extends State<ListNotificationScreen>
    implements SharedPreferencesContract {
  SharedPreferencesPresenter? _preferencesPresenter;
  int _selectedIndex = 2;
  bool _isOwner = true;

  late String rentalID;
  late Room yourRoom;
  String? uID = FirebaseAuth.instance.currentUser?.uid;

  final ReceiptRepository _receiptRepository = ReceiptRepositoryIml();
  late List<Receipt> receipts;

  @override
  void initState() {
    super.initState();
    _preferencesPresenter = SharedPreferencesPresenter(this);
    _preferencesPresenter?.getUserInfoFromSharedPreferences();
    _loadYourRoom();
  }

  Future<void> _loadYourRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rentalID = prefs.getString('yourRoomId') ?? '';
    if (rentalID.isNotEmpty) {
      yourRoom = await RoomRepositoryIml().getRoomById(rentalID);
    }
  }

  List<Receipt> loadListReceipt(List<Receipt> list) {
    List<Receipt> newList = List.from(list);

    newList = list.where((element) => element.tenantID == uID).toList();
    newList.sort((a, b) => b.createdDay.compareTo(a.createdDay));
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Notification',
            style: TextStyles.title.copyWith(
              fontSize: 32,
              shadows: [
                const Shadow(
                  color: Colors.black12,
                  offset: Offset(3, 6),
                  blurRadius: 6,
                )
              ],
            ),
          ),
        ),
      ),
      body: _isOwner
          ? Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                margin: EdgeInsets.symmetric(
                    horizontal: 15, vertical: size.height * 0.37),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorPalette.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ColorPalette.primaryColor,
                    width: 2,
                  ),
                ),
                child: const Text('You have no Notifications!!!'),
              ),
            )
          : Expanded(
              child: StreamBuilder<List<Receipt>>(
                stream: _receiptRepository.getReceipts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something went wrong! ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    receipts = snapshot.data!;
                    return ListView(
                      children: loadListReceipt(receipts)
                          .map((e) => ReceiptItem(receipt: e))
                          .toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
      bottomNavigationBar: SalomonBottomBar(
          backgroundColor: ColorPalette.backgroundColor,
          currentIndex: _selectedIndex,
          onTap: (id) {
            if (!_isOwner && rentalID.isNotEmpty) {
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
                  if (rentalID.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailRoomScreen(
                          room: yourRoom,
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
  void updateView(
      String? userName, bool? isOwner, String? userAvatarUrl, String? email) {
    setState(() {
      _isOwner = isOwner ?? true;
    });
  }
}
