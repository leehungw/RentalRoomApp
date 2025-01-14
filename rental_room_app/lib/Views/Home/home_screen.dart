import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_room_app/Contract/Home/home_contract.dart';
import 'package:rental_room_app/Services/shared_preferences_contract.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Models/Room/room_repo.dart';
import 'package:rental_room_app/Presenter/Home/home_presenter.dart';
import 'package:rental_room_app/Services/shared_preferences_presenter.dart';
import 'package:rental_room_app/Views/YourRoom/detail_room_screen.dart';
import 'package:rental_room_app/config/asset_helper.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/Views/Home/Subviews/filter_container_widget.dart';
import 'package:rental_room_app/widgets/owner_room_item.dart';
import 'package:rental_room_app/widgets/room_item.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    implements SharedPreferencesContract, HomeContract {
  SharedPreferencesPresenter? _preferencesPresenter;
  HomePresenter? _homePresenter;
  final RoomRepository _roomRepository = RoomRepositoryIml();

  int _selectedIndex = 0;
  String _userName = "nguyen van a";
  bool _isOwner = true;
  String _userAvatarUrl = '';
  final bool _isVisiable = false;
  bool _isVisibleFilter = false;
  final int _soLuongPhongCoSan = 6;
  bool _show = true;

  late List<Room> _roomAvailable;
  String _rentalID = '';
  late Room _yourRoom;

  bool? priceDesc;
  bool? areaDesc;
  bool? rateDesc;
  String? kindRoom;
  String? valueSearch;
  String? dropdownKindValue;

  String _recommendTextError = "Service Unavailable!";

  @override
  void initState() {
    super.initState();
    _preferencesPresenter = SharedPreferencesPresenter(this);
    _preferencesPresenter?.getUserInfoFromSharedPreferences();
    _homePresenter = HomePresenter(this);
    _homePresenter?.requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        color: ColorPalette.backgroundColor,
        child: Column(
          children: [
            const Gap(30),
            SizedBox(
              width: size.width,
              child: GestureDetector(
                onTap: () {
                  GoRouter.of(context).go('/setting');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('WELCOME',
                            style: TextStyle(
                                fontSize: 10, color: ColorPalette.grayText)),
                        Text(
                          _userName,
                          style: const TextStyle(
                              fontSize: 16, color: ColorPalette.primaryColor),
                        ),
                      ],
                    ),
                    const Gap(15),
                    Container(
                      height: 35,
                      width: 35,
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
                    )
                  ],
                ),
              ),
            ),
            const Gap(20),
            SizedBox(
              height: 42,
              width: double.infinity,
              child: TextField(
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) {
                    setState(() {
                      valueSearch = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: ColorPalette.primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: ColorPalette.primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.only(top: 4),
                    prefixIcon: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {},
                      child: const Icon(
                        FontAwesomeIcons.magnifyingGlass,
                        size: 16,
                        color: ColorPalette.greenText,
                      ),
                    ),
                    suffixIcon: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        setState(() {
                          _isVisibleFilter = !_isVisibleFilter;
                        });
                      },
                      child: const Icon(
                        FontAwesomeIcons.barsProgress,
                        size: 16,
                        color: ColorPalette.primaryColor,
                      ),
                    ),
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: ColorPalette.grayText,
                    ),
                  )),
            ),
            const Gap(10),
            Container(
              alignment: Alignment.centerLeft,
              child: Visibility(
                visible: _isVisibleFilter,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.filter,
                          color: ColorPalette.greenText,
                          size: 15,
                        ),
                        const Gap(10),
                        Text(
                          'Filter',
                          style: TextStyles.titleHeading.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilterContainerWidget(
                          name: 'Area',
                          icon1: const Icon(
                            FontAwesomeIcons.arrowUp,
                            color: ColorPalette.primaryColor,
                            size: 10,
                          ),
                          icon2: const Icon(
                            FontAwesomeIcons.arrowDown,
                            color: ColorPalette.primaryColor,
                            size: 10,
                          ),
                          onTapIconDown: () {
                            setState(() {
                              areaDesc = true;
                            });
                          },
                          onTapIconUp: () {
                            setState(() {
                              areaDesc = false;
                            });
                          },
                        ),
                        FilterContainerWidget(
                          name: 'Price',
                          icon1: const Icon(
                            FontAwesomeIcons.arrowUp,
                            color: ColorPalette.primaryColor,
                            size: 10,
                          ),
                          icon2: const Icon(
                            FontAwesomeIcons.arrowDown,
                            color: ColorPalette.primaryColor,
                            size: 10,
                          ),
                          onTapIconDown: () {
                            setState(() {
                              priceDesc = true;
                            });
                          },
                          onTapIconUp: () {
                            setState(() {
                              priceDesc = false;
                            });
                          },
                        ),
                        FilterContainerWidget(
                          name: 'Rate',
                          icon1: const Icon(
                            FontAwesomeIcons.arrowUp,
                            color: ColorPalette.primaryColor,
                            size: 10,
                          ),
                          icon2: const Icon(
                            FontAwesomeIcons.arrowDown,
                            color: ColorPalette.primaryColor,
                            size: 10,
                          ),
                          onTapIconDown: () {},
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: ColorPalette.grayText)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            child: SizedBox(
                              height: 15,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(15),
                                  hint: Text(
                                    'Kind',
                                    style: TextStyles.defaultStyle.grayText
                                        .copyWith(fontSize: 12),
                                  ),
                                  value: kindRoom,
                                  style: TextStyles.defaultStyle.grayText
                                      .copyWith(fontSize: 12),
                                  icon: const Icon(
                                    FontAwesomeIcons.arrowDown,
                                    color: ColorPalette.primaryColor,
                                    size: 10,
                                  ),
                                  items: <String>[
                                    'All',
                                    'Standard',
                                    'Loft',
                                    'House'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      kindRoom = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Gap(10),
            Container(
              alignment: Alignment.centerLeft,
              child: Visibility(
                visible:
                    !_isOwner && (valueSearch == '' || valueSearch == null),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Suggestion For You',
                          style: TextStyles.titleHeading,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _show = !_show;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                _show ? 'Hide' : 'Show',
                                style: TextStyles.seeAll.copyWith(fontSize: 14),
                              ),
                              const Gap(3),
                              Icon(
                                _show
                                    ? FontAwesomeIcons.angleUp
                                    : FontAwesomeIcons.angleDown,
                                size: 15,
                                color: ColorPalette.grayText,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    _isOwner
                        ? Container()
                        : Visibility(
                            visible: _show,
                            child: FutureBuilder(
                              future: _roomRepository.getRecommendedRooms(
                                  FirebaseAuth.instance.currentUser!.uid),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Container();
                                } else if (snapshot.hasData) {
                                  if (snapshot.data!.isEmpty) {
                                    return Center(
                                      child: Text(
                                        "Empty list",
                                        style: TextStyles.titleHeading.copyWith(
                                            color: ColorPalette.errorColor),
                                      ),
                                    );
                                  }
                                  List<Room> recommendedRooms = snapshot.data!;
                                  return SizedBox(
                                    height: 350,
                                    width: size.width,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: recommendedRooms
                                          .map((room) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: SizedBox(
                                                    width: 170,
                                                    child:
                                                        RoomItem(room: room)),
                                              ))
                                          .toList(),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      "Loading",
                                      style: TextStyles.titleHeading.copyWith(
                                          color: ColorPalette.errorColor),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
            const Gap(15),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isOwner ? 'Your Room' : 'Room Available',
                        style: TextStyles.titleHeading,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(10),
            Expanded(
              child: StreamBuilder<List<Room>>(
                stream: _isOwner
                    ? _roomRepository.getOwnedRoom()
                    : _roomRepository.getRooms(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something went wrong! ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    _roomAvailable = snapshot.data!;
                    return GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.5,
                        children: _roomAvailable
                            .map((e) => OwnerRoomItem(room: e))
                            .toList());
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isOwner
          ? FloatingActionButton(
              backgroundColor: ColorPalette.primaryColor.withOpacity(0.8),
              shape: const CircleBorder(),
              onPressed: () {
                GoRouter.of(context).go('/home/create_room');
              },
              child: const Icon(
                FontAwesomeIcons.plus,
                size: 30,
                color: Colors.white,
              ),
            )
          : null,
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
        ],
      ),
    );
  }

  @override
  void updateView(String? userName, bool? isOwner, String? userAvatarUrl,
      String? email, String? rentalId) {
    setState(() {
      _userName = userName ?? "null";
      _isOwner = isOwner ?? true;
      _userAvatarUrl = userAvatarUrl ?? "";
      _rentalID = rentalId ?? "";

      if (_rentalID.isNotEmpty) {
        _homePresenter?.loadRentalRoom(_rentalID);
      }
    });
  }

  @override
  void onRecommendFailed() {
    setState(() {
      _recommendTextError = "Service Unavailable!";
    });
  }

  @override
  void onRecommendSuccess() {
    setState(() {
      _recommendTextError = "";
    });
  }

  @override
  void onUpdateYourRoom(Room yourRoom) {
    setState(() {
      _yourRoom = yourRoom;
    });
  }
}
