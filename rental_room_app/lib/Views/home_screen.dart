import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rental_room_app/Contract/home_contract.dart';
import 'package:rental_room_app/Contract/shared_preferences_presenter.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Models/Room/room_repo.dart';
import 'package:rental_room_app/Models/User/user_model.dart';
import 'package:rental_room_app/Presenter/home_presenter.dart';
import 'package:rental_room_app/Presenter/shared_preferences_presenter.dart';
import 'package:rental_room_app/Views/detail_room_screen.dart';
import 'package:rental_room_app/config/asset_helper.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/filter_container_widget.dart';
import 'package:rental_room_app/widgets/owner_room_item.dart';
import 'package:rental_room_app/widgets/room_item.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final docRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid);

  int _selectedIndex = 0;
  String _userName = "nguyen van a";
  bool _isOwner = true;
  String _userAvatarUrl = '';
  bool isVisiable = false;
  bool isVisibleFilter = false;
  int soLuongPhongCoSan = 6;
  bool show = true;

  late List<Room> roomAvailable;
  String rentalID = '';
  final String userID = FirebaseAuth.instance.currentUser!.uid;
  late Room yourRoom;

  bool? priceDesc;
  bool? areaDesc;
  bool? rateDesc;
  String? kindRoom;
  String? valueSearch;
  String? dropdownKindValue;

  String _recommendTextError = "Service Unavailable!";

  List<Room> loadListOwnerRoom(List<Room> list) {
    List<Room> newList = List.from(list);
    newList = list.where((element) => element.ownerId == userID).toList();
    if (priceDesc == true) {
      newList.sort((a, b) => b.price.roomPrice.compareTo(a.price.roomPrice));
    }
    if (priceDesc == false) {
      newList.sort((a, b) => a.price.roomPrice.compareTo(b.price.roomPrice));
    }
    if (areaDesc == true) {
      newList.sort((a, b) => b.area.compareTo(a.area));
    }
    if (areaDesc == false) {
      newList.sort((a, b) => a.area.compareTo(b.area));
    }

    switch (kindRoom) {
      case 'All':
        break;
      case 'Standard':
        newList = newList
            .where((element) =>
                element.kind == 'Standard Room' && element.isAvailable)
            .toList();
        break;
      case 'Loft':
        newList = newList
            .where(
                (element) => element.kind == 'Loft Room' && element.isAvailable)
            .toList();
        break;
      case 'House':
        newList = newList
            .where((element) => element.kind == 'House' && element.isAvailable)
            .toList();
        break;
      default:
        break;
    }
    if (valueSearch != null) {
      newList = newList
          .where((element) =>
              element.location
                  .toLowerCase()
                  .contains(valueSearch!.toLowerCase()) &&
              element.isAvailable)
          .toList();
    }
    return newList;
  }

  List<Room> loadListRoom(List<Room> list) {
    List<Room> newList = List.from(list);
    newList = list.where((element) => element.isAvailable == true).toList();
    if (priceDesc == true) {
      newList.sort((a, b) => b.price.roomPrice.compareTo(a.price.roomPrice));
    }
    if (priceDesc == false) {
      newList.sort((a, b) => a.price.roomPrice.compareTo(b.price.roomPrice));
    }
    if (areaDesc == true) {
      newList.sort((a, b) => b.area.compareTo(a.area));
    }
    if (areaDesc == false) {
      newList.sort((a, b) => a.area.compareTo(b.area));
    }
    switch (kindRoom) {
      case 'All':
        break;
      case 'Standard':
        newList = newList
            .where((element) =>
                element.kind == 'Standard Room' && element.isAvailable)
            .toList();
        break;
      case 'Loft':
        newList = newList
            .where(
                (element) => element.kind == 'Loft Room' && element.isAvailable)
            .toList();
        break;
      case 'House':
        newList = newList
            .where((element) => element.kind == 'House' && element.isAvailable)
            .toList();
        break;
      default:
        break;
    }
    if (valueSearch != null) {
      newList = newList
          .where((element) =>
              element.location
                  .toLowerCase()
                  .contains(valueSearch!.toLowerCase()) &&
              element.isAvailable)
          .toList();
    }
    return newList;
  }

  @override
  void initState() {
    super.initState();
    _preferencesPresenter = SharedPreferencesPresenter(this);
    _preferencesPresenter?.getUserInfoFromSharedPreferences();
    _homePresenter = HomePresenter(this);
    _loadRentalRoom();
    requestLocationPermission();

    docRef.snapshots().listen(
          (event) => setState(() {}),
          onError: (error) => print("Listen failed: $error"),
        );
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (!status.isGranted) {
      PermissionStatus result = await Permission.location.request();
      if (result.isDenied) {
        print('Permission denied');
      }
    }
  }

  Future<void> _loadRentalRoom() async {
    CollectionReference rentalroomRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('rentalroom');

    try {
      // Truy vấn tất cả các documents bên trong rentalroom
      QuerySnapshot querySnapshot = await rentalroomRef.get();

      if (querySnapshot.docs.isEmpty) {
        print('No documents found.');
        return;
      }

      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> rentalRoomData =
          documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        rentalID = rentalRoomData['roomID'];
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('yourRoomId', rentalID);
      if (rentalID.isNotEmpty) {
        yourRoom = await RoomRepositoryIml().getRoomById(rentalID);
      }
    } catch (e) {
      print('Error getting document: $e');
    }
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
                          isVisibleFilter = !isVisibleFilter;
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
                visible: isVisibleFilter,
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
                              show = !show;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                show ? 'Hide' : 'Show',
                                style: TextStyles.seeAll.copyWith(fontSize: 14),
                              ),
                              Gap(3),
                              Icon(
                                show
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
                            visible: show,
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
                                    height: 250,
                                    width: size.width,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: recommendedRooms
                                          .map((room) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: SizedBox(
                                                    height: 250,
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
                stream: _roomRepository.getRooms(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something went wrong! ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    roomAvailable = snapshot.data!;
                    return GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.7,
                      children: _isOwner
                          ? loadListOwnerRoom(roomAvailable)
                              .map((e) => OwnerRoomItem(room: e))
                              .toList()
                          : loadListRoom(roomAvailable)
                              .map((e) => RoomItem(room: e))
                              .toList(),
                    );
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
        ],
      ),
    );
  }

  @override
  void updateView(
      String? userName, bool? isOwner, String? userAvatarUrl, String? email) {
    setState(() {
      _userName = userName ?? "null";
      _isOwner = isOwner ?? true;
      _userAvatarUrl = userAvatarUrl ?? "";
    });
  }

  @override
  void onRecommendFailed() {
    _recommendTextError = "Service Unavailable!";
    setState(() {});
  }

  @override
  void onRecommendSuccess() {
    _recommendTextError = "";
    setState(() {});
  }
}
