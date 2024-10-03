import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_room_app/Contract/YourRoom/report_contract.dart';
import 'package:rental_room_app/Presenter/YourRoom/report_presenter.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  static const String routeName = 'report_screen';

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> implements ReportContract {
  ReportPresenter? _reportPresenter;
  int _selectedIndex = 1;
  int _totalRoom = 0;

  final String oID = FirebaseAuth.instance.currentUser!.uid;

  bool isLoading = true;
  Map<String, int> totalRooms = {
    'Standard Room': 0,
    'Loft Room': 0,
    'House': 0
  };
  Map<String, int> occupiedRooms = {
    'Standard Room': 0,
    'Loft Room': 0,
    'House': 0
  };

  @override
  void initState() {
    super.initState();
    _reportPresenter = ReportPresenter(this);
    _fetchRoomData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette.primaryColor,
        title: Text(
          'STATISTIC',
          style: TextStyles.h8.bold.copyWith(
            shadows: [
              const Shadow(
                color: Colors.black12,
                offset: Offset(3, 6),
                blurRadius: 6,
              )
            ],
            letterSpacing: 1.175,
          ),
        ),
        centerTitle: true,
        toolbarHeight: kToolbarHeight * 1.5,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _totalRoom == 0
              ? Container()
              : Center(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Standard',
                                  style: TextStyles.noInternetTitle.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                const Gap(10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: ((size.height * 0.6 - 50) /
                                                  _totalRoom) *
                                              totalRooms['Standard Room']!,
                                          width: size.width / 12,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text('${totalRooms['Standard Room']}'),
                                      ],
                                    ),
                                    const Gap(5),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: ((size.height * 0.6 - 50) /
                                                  _totalRoom) *
                                              occupiedRooms['Standard Room']!,
                                          width: size.width / 12,
                                          decoration: const BoxDecoration(
                                            color: Colors.orange,
                                          ),
                                        ),
                                        Text(
                                            '${occupiedRooms['Standard Room']}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Loft Room
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Loft',
                                  style: TextStyles.noInternetTitle.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                const Gap(10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: ((size.height * 0.6 - 50) /
                                                  _totalRoom) *
                                              totalRooms['Loft Room']!,
                                          width: size.width / 12,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text('${totalRooms['Loft Room']}'),
                                      ],
                                    ),
                                    const Gap(5),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: ((size.height * 0.6 - 50) /
                                                  _totalRoom) *
                                              occupiedRooms['Loft Room']!,
                                          width: size.width / 12,
                                          decoration: const BoxDecoration(
                                            color: Colors.orange,
                                          ),
                                        ),
                                        Text('${occupiedRooms['Loft Room']}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // House
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'House',
                                  style: TextStyles.noInternetTitle.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                const Gap(10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: ((size.height * 0.6 - 50) /
                                                  _totalRoom) *
                                              totalRooms['House']!,
                                          width: size.width / 12,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text('${totalRooms['House']}'),
                                      ],
                                    ),
                                    const Gap(5),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: ((size.height * 0.6 - 50) /
                                                  _totalRoom) *
                                              occupiedRooms['House']!,
                                          width: size.width / 12,
                                          decoration: const BoxDecoration(
                                            color: Colors.orange,
                                          ),
                                        ),
                                        Text('${occupiedRooms['House']}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: size.width / 12,
                              width: size.width / 12,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                              ),
                            ),
                            const Gap(15),
                            Text(
                              'Total Room',
                              style: TextStyles.noInternetDes
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: size.width / 12,
                              width: size.width / 12,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                              ),
                            ),
                            const Gap(15),
                            Text(
                              'Rented Room',
                              style: TextStyles.noInternetDes
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
              GoRouter.of(context).go('/report');
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

  void _fetchRoomData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Rooms')
        .where('ownerId', isEqualTo: oID)
        .get();

    Map<String, int> tempTotalRooms = {
      'Standard Room': 0,
      'Loft Room': 0,
      'House': 0
    };
    Map<String, int> tempOccupiedRooms = {
      'Standard Room': 0,
      'Loft Room': 0,
      'House': 0
    };

    for (var doc in snapshot.docs) {
      String roomType = doc['kind'];
      bool isAvailable = doc['isAvailable'];

      if (tempTotalRooms.containsKey(roomType)) {
        tempTotalRooms[roomType] = tempTotalRooms[roomType]! + 1;
        if (!isAvailable) {
          tempOccupiedRooms[roomType] = tempOccupiedRooms[roomType]! + 1;
        }
      } else {
        print('Room type $roomType is not recognized.');
      }
    }

    setState(() {
      totalRooms = tempTotalRooms;
      occupiedRooms = tempOccupiedRooms;
      isLoading = false;
      totalRooms.forEach((key, value) {
        _totalRoom += value;
      });
    });
  }
}
