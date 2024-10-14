import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:rental_room_app/Contract/YourRoom/detail_room_contract.dart';
import 'package:rental_room_app/Models/Comment/comment_model.dart';
import 'package:rental_room_app/Models/Comment/comment_repo.dart';
import 'package:rental_room_app/Models/Rental/rental_model.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Models/User/user_model.dart';
import 'package:rental_room_app/Presenter/YourRoom/detail_room_presenter.dart';
import 'package:rental_room_app/Services/shared_preferences_contract.dart';
import 'package:rental_room_app/Services/shared_preferences_presenter.dart';
import 'package:rental_room_app/Views/Home/home_screen.dart';
import 'package:rental_room_app/Views/YourRoom/edit_form_screen.dart';
import 'package:rental_room_app/Views/YourRoom/edit_room_screen.dart';
import 'package:rental_room_app/Views/YourRoom/new_receipt_screen.dart';
import 'package:rental_room_app/Views/YourRoom/rental_form_screen.dart';
import 'package:rental_room_app/config/asset_helper.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/border_container.dart';
import 'package:rental_room_app/widgets/comment.dart';
import 'package:rental_room_app/widgets/model_button.dart';
import 'package:rental_room_app/widgets/sub_image_frame.dart';

class DetailRoomScreen extends StatefulWidget {
  final Room room;
  const DetailRoomScreen({super.key, required this.room});
  static const String routeName = "detail_room";

  @override
  State<DetailRoomScreen> createState() => _DetailRoomScreenState();
}

class _DetailRoomScreenState extends State<DetailRoomScreen>
    implements DetailRoomContract, SharedPreferencesContract {
  DetailRoomPresenter? _detailRoomPresenter;
  final CommentRepository _commentRepository = CommentRepositoryIml();
  final _formKey = GlobalKey<FormState>();
  late SharedPreferencesPresenter _sharedPreferencesPresenter;

  bool isPressed = false;
  final PageController _pageController = PageController();
  int _currenImage = 0;
  List<String> images = [
    AssetHelper.priImage,
    AssetHelper.subOne,
    AssetHelper.subTwo,
    AssetHelper.subThree
  ];

  final int numberstar = 5;
  double rating = 0;

  bool _isOwner = false;

  Rental? _rental;
  Users? _user;
  String _rentalID = '';
  String _status = 'Loading ...';

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _detailRoomPresenter = DetailRoomPresenter(this);
    _sharedPreferencesPresenter = SharedPreferencesPresenter(this);
    _sharedPreferencesPresenter.getUserInfoFromSharedPreferences();
    _detailRoomPresenter?.updateLatestTappedRoom(widget.room.roomId);
    _detailRoomPresenter?.beginProgram(widget.room, _rentalID);
  }

  @override
  Widget build(BuildContext context) {
    Room room = widget.room;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currenImage = index;
                    });
                  },
                  itemCount: room.secondaryImgUrls.length + 1,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 250,
                      alignment: Alignment.bottomCenter,
                      child: index == 0
                          ? Image.network(
                              room.primaryImgUrl,
                              fit: BoxFit.cover,
                              height: 250,
                              width: size.width,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Container(
                                  height: 250,
                                );
                              },
                            )
                          : Image.network(
                              room.secondaryImgUrls[index - 1],
                              fit: BoxFit.cover,
                              height: 250,
                              width: size.width,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Container(
                                  height: 250,
                                );
                              },
                            ),
                    );
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 90,
                      padding:
                          const EdgeInsets.only(left: 20, right: 42, top: 50),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: isPressed
                                  ? ColorPalette.primaryColor
                                  : ColorPalette.backgroundColor,
                            ),
                          ),
                          Expanded(
                              child: Center(
                                  child: Text(
                            room.roomName,
                            style: TextStyles.h8,
                          ))),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 21 *
                                (room.secondaryImgUrls.length + 1).toDouble(),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: room.secondaryImgUrls.length + 1,
                              itemBuilder: (context, index) {
                                return imageIndicator(index == _currenImage);
                              },
                            ),
                          ),
                          if (_isOwner)
                            Container(
                              width: size.width,
                              alignment: Alignment.bottomRight,
                              child: Container(
                                alignment: Alignment.center,
                                height: 25,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: widget.room.isAvailable
                                      ? Colors.greenAccent.withOpacity(0.8)
                                      : Colors.orangeAccent.withOpacity(0.8),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  widget.room.isAvailable
                                      ? 'Available'
                                      : 'Rented',
                                  style: TextStyles.nameRoomItem.copyWith(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BorderContainer(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.locationPin,
                            size: 24,
                            color: ColorPalette.primaryColor.withOpacity(0.44),
                          ),
                          const Gap(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Location',
                                style: TextStyles.detailTitle,
                              ),
                              SizedBox(
                                width: size.width - 120,
                                child: Text(
                                  room.location,
                                  style: TextStyles.descriptionRoom,
                                  softWrap: true,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    BorderContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Photos',
                            style: TextStyles.detailTitle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (room.secondaryImgUrls.isNotEmpty)
                                SubFrame(
                                  child: Image.network(
                                    room.secondaryImgUrls[0],
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Container();
                                    },
                                  ),
                                ),
                              if (room.secondaryImgUrls.length > 1)
                                SubFrame(
                                  child: Image.network(
                                    room.secondaryImgUrls[1],
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Container();
                                    },
                                  ),
                                ),
                              if (room.secondaryImgUrls.length > 2)
                                SubFrame(
                                  child: Image.network(
                                    room.secondaryImgUrls[2],
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Container();
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    BorderContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyles.detailTitle,
                          ),
                          Text(
                            room.description,
                            style: TextStyles.descriptionRoom,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                BorderContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kind',
                        style: TextStyles.detailTitle,
                      ),
                      Text(
                        room.kind,
                        style: TextStyles.descriptionRoom,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                BorderContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Area',
                        style: TextStyles.detailTitle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            room.area.toString(),
                            style: TextStyles.descriptionRoom,
                            textAlign: TextAlign.justify,
                          ),
                          const Text(
                            'm2',
                            style: TextStyles.descriptionRoom,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                BorderContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyles.detailTitle,
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 50,
                                child: const Icon(
                                  FontAwesomeIcons.houseChimney,
                                  size: 15,
                                  color: ColorPalette.primaryColor,
                                ),
                              ),
                              Text(
                                room.price.roomPrice.toString(),
                                style: TextStyles.descriptionRoom,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          const Text(
                            'VND/Month',
                            style: TextStyles.descriptionRoom,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 50,
                                child: const Icon(
                                  Icons.water_drop_sharp,
                                  size: 15,
                                  color: ColorPalette.primaryColor,
                                ),
                              ),
                              Text(
                                room.price.waterPrice.toString(),
                                style: TextStyles.descriptionRoom,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          const Text(
                            'VND/m3',
                            style: TextStyles.descriptionRoom,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 50,
                                child: const Icon(
                                  FontAwesomeIcons.boltLightning,
                                  size: 15,
                                  color: ColorPalette.primaryColor,
                                ),
                              ),
                              Text(
                                room.price.electricPrice.toString(),
                                style: TextStyles.descriptionRoom,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          const Text(
                            'VND/kWh',
                            style: TextStyles.descriptionRoom,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 50,
                                child: const Icon(
                                  Icons.receipt_long,
                                  size: 15,
                                  color: ColorPalette.primaryColor,
                                ),
                              ),
                              Text(
                                room.price.othersPrice.toString(),
                                style: TextStyles.descriptionRoom,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          const Text(
                            'VND/Month',
                            style: TextStyles.descriptionRoom,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                BorderContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Owner Information',
                        style: TextStyles.detailTitle,
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            child: const Icon(
                              FontAwesomeIcons.user,
                              size: 15,
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          Text(
                            room.ownerName,
                            style: TextStyles.descriptionRoom,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            child: const Icon(
                              Icons.phone,
                              size: 15,
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          Text(
                            room.ownerPhone,
                            style: TextStyles.descriptionRoom,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            child: const Icon(
                              FontAwesomeIcons.envelope,
                              size: 15,
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          Text(
                            room.ownerEmail,
                            style: TextStyles.descriptionRoom,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            child: const Icon(
                              FontAwesomeIcons.squareFacebook,
                              size: 15,
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          Text(
                            room.ownerFacebook,
                            style: TextStyles.descriptionRoom,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            child: const Icon(
                              Icons.location_on,
                              size: 15,
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: size.width - 120,
                            child: Text(
                              room.ownerAddress,
                              style: TextStyles.descriptionRoom,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                if (!room.isAvailable)
                  Column(
                    children: [
                      BorderContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rental Information',
                              style: TextStyles.detailTitle,
                            ),
                            const Gap(10),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: const Icon(
                                    FontAwesomeIcons.user,
                                    size: 15,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ),
                                Text(
                                  _user?.getUserName ?? 'Nguyen Nguoi Thue',
                                  style: TextStyles.descriptionRoom,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: const Icon(
                                    Icons.male,
                                    size: 15,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ),
                                Text(
                                  _user?.getGender ?? 'Male',
                                  style: TextStyles.descriptionRoom,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: const Icon(
                                    Icons.phone_outlined,
                                    size: 15,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ),
                                Text(
                                  _user?.getPhone ?? '0123456789',
                                  style: TextStyles.descriptionRoom,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: const Icon(
                                    Icons.business,
                                    size: 15,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ),
                                Text(
                                  _rental?.identity ?? '123456789',
                                  style: TextStyles.descriptionRoom,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: const Icon(
                                    FontAwesomeIcons.envelope,
                                    size: 15,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ),
                                Text(
                                  _user?.getEmail ?? 'abcde@gmail.com',
                                  style: TextStyles.descriptionRoom,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: const Icon(
                                    Icons.cake_outlined,
                                    size: 15,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(
                                      _user?.getBirthday ??
                                          DateTime.parse('2000-01-01')),
                                  style: TextStyles.descriptionRoom,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: const Icon(
                                    Icons.people_alt_outlined,
                                    size: 15,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ),
                                Text(
                                  _rental?.numberPeople.toString() ?? '1',
                                  style: TextStyles.descriptionRoom,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: const Icon(
                                    FontAwesomeIcons.solidHourglassHalf,
                                    size: 15,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ),
                                Text(
                                  '${_rental?.duration.toString() ?? '12'} months',
                                  style: TextStyles.descriptionRoom,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: const Icon(
                                    FontAwesomeIcons.moneyBillWave,
                                    size: 15,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ),
                                Text(
                                  '${_rental?.deposit.toStringAsFixed(0) ?? '1000000'} VNĐ',
                                  style: TextStyles.descriptionRoom,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: const Icon(
                                    FontAwesomeIcons.squareFacebook,
                                    size: 15,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ),
                                Text(
                                  _rental?.facebook ??
                                      'https://www.facebook.com',
                                  style: TextStyles.descriptionRoom,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Receipt Status:',
                            style: TextStyles.receiptStatus,
                          ),
                          Text(
                            _status,
                            style: TextStyles.descriptionRoom
                                .copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                      const Gap(10),
                    ],
                  ),
                if (!room.isAvailable && !_isOwner)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: ModelButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditFormScreen(
                                  room: widget.room,
                                ),
                              ),
                            );
                          },
                          name: 'EDIT FORM',
                          color: ColorPalette.primaryColor.withOpacity(0.75),
                          width: 150,
                        ),
                      ),
                      const Gap(5),
                      Container(
                        alignment: Alignment.center,
                        child: ModelButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Notification'),
                                  content: const Text(
                                      'Are you sure you want to check out this room?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('CANCEL'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _detailRoomPresenter?.checkOutRoom(
                                            widget.room.roomId, _rentalID);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          name: 'CHECK OUT',
                          color: ColorPalette.redColor,
                          width: 150,
                        ),
                      ),
                    ],
                  ),
                if (room.isAvailable && !_isOwner)
                  Container(
                    alignment: Alignment.center,
                    child: ModelButton(
                      onTap: () async {
                        bool isHaveRoom =
                            await _detailRoomPresenter?.isHaveRoom() ?? false;
                        if (isHaveRoom) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Notification'),
                                content: const Text(
                                    'You have already rented a room. Please check out before renting another room!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RentalFormScreen(
                                room: widget.room,
                              ),
                            ),
                          );
                        }
                      },
                      name: 'Rental',
                      color: ColorPalette.primaryColor.withOpacity(0.75),
                      width: 150,
                    ),
                  ),
                if (room.isAvailable && _isOwner)
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: ModelButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditRoomScreen(
                                  room: widget.room,
                                ),
                              ),
                            );
                          },
                          name: 'Edit room',
                          color: ColorPalette.primaryColor.withOpacity(0.75),
                          width: 150,
                        ),
                      ),
                      const Gap(10),
                      Container(
                        alignment: Alignment.center,
                        child: ModelButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Notification'),
                                  content: const Text(
                                      'Are you sure you want to DELETE this room?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _detailRoomPresenter
                                            ?.deleteRoom(widget.room.roomId);
                                      },
                                      child: const Text('CONFIRM'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          name: 'Delete room',
                          color: ColorPalette.redColor,
                          width: 150,
                        ),
                      ),
                    ],
                  ),
                if (!room.isAvailable && _isOwner)
                  Container(
                    alignment: Alignment.center,
                    child: ModelButton(
                      onTap: () {
                        if (_status != 'No receipt') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Notification'),
                                content: const Text(
                                    'You have already created a receipt. Please wait before creating another receipt!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewReceipt(
                                room: widget.room,
                                tenantID: _rentalID,
                              ),
                            ),
                          );
                        }
                      },
                      name: 'New Receipt',
                      color: ColorPalette.primaryColor.withOpacity(0.75),
                      width: 150,
                    ),
                  ),
                const Gap(10),
                FutureBuilder(
                    future: _commentRepository
                        .getAllCommentsbyRoomId(widget.room.roomId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Comment>? comments = snapshot.data;
                        comments?.sort((a, b) => a.time.compareTo(b.time));

                        double avgRating = comments!.isEmpty
                            ? 0
                            : comments
                                    .map((m) => m.rating)
                                    .reduce((a, b) => a + b) /
                                comments.length;
                        return Column(
                          children: [
                            BorderContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Rating',
                                    style: TextStyles.detailTitle,
                                  ),
                                  const Gap(5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 130,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              avgRating.toStringAsFixed(1),
                                              style: TextStyles.ratingNumb,
                                            ),
                                            RatingBar.builder(
                                              initialRating: avgRating,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 18,
                                              unratedColor:
                                                  const Color(0xffDADADA),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (value) {},
                                              ignoreGestures: true,
                                            ),
                                            Text(
                                              comments.length.toString(),
                                              style: TextStyles.ratingText,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(15),
                                      SizedBox(
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            SizedBox(
                                              width: size.width - 180,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    '5',
                                                    style:
                                                        TextStyles.ratingText,
                                                  ),
                                                  SizedBox(
                                                    width: size.width - 190,
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: comments.isEmpty
                                                          ? 0
                                                          : comments
                                                                  .where((e) =>
                                                                      e.rating >=
                                                                      4)
                                                                  .toList()
                                                                  .length /
                                                              comments.length,
                                                      backgroundColor:
                                                          const Color(
                                                              0xffDADADA),
                                                      valueColor:
                                                          const AlwaysStoppedAnimation<
                                                                  Color>(
                                                              ColorPalette
                                                                  .primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      minHeight: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width - 180,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    '4',
                                                    style:
                                                        TextStyles.ratingText,
                                                  ),
                                                  SizedBox(
                                                    width: size.width - 190,
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: comments.isEmpty
                                                          ? 0
                                                          : comments
                                                                  .where((e) =>
                                                                      e.rating >=
                                                                          3 &&
                                                                      e.rating <
                                                                          4)
                                                                  .toList()
                                                                  .length /
                                                              comments.length,
                                                      backgroundColor:
                                                          const Color(
                                                              0xffDADADA),
                                                      valueColor:
                                                          const AlwaysStoppedAnimation<
                                                                  Color>(
                                                              ColorPalette
                                                                  .primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      minHeight: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width - 180,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    '3',
                                                    style:
                                                        TextStyles.ratingText,
                                                  ),
                                                  SizedBox(
                                                    width: size.width - 190,
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: comments.isEmpty
                                                          ? 0
                                                          : comments
                                                                  .where((e) =>
                                                                      e.rating >=
                                                                          2 &&
                                                                      e.rating <
                                                                          3)
                                                                  .toList()
                                                                  .length /
                                                              comments.length,
                                                      backgroundColor:
                                                          const Color(
                                                              0xffDADADA),
                                                      valueColor:
                                                          const AlwaysStoppedAnimation<
                                                                  Color>(
                                                              ColorPalette
                                                                  .primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      minHeight: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width - 180,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    '2',
                                                    style:
                                                        TextStyles.ratingText,
                                                  ),
                                                  SizedBox(
                                                    width: size.width - 190,
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: comments.isEmpty
                                                          ? 0
                                                          : comments
                                                                  .where((e) =>
                                                                      e.rating >=
                                                                          1 &&
                                                                      e.rating <
                                                                          2)
                                                                  .toList()
                                                                  .length /
                                                              comments.length,
                                                      backgroundColor:
                                                          const Color(
                                                              0xffDADADA),
                                                      valueColor:
                                                          const AlwaysStoppedAnimation<
                                                                  Color>(
                                                              ColorPalette
                                                                  .primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      minHeight: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width - 180,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    '1',
                                                    style:
                                                        TextStyles.ratingText,
                                                  ),
                                                  SizedBox(
                                                    width: size.width - 190,
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: comments.isEmpty
                                                          ? 0
                                                          : comments
                                                                  .where((e) =>
                                                                      e.rating >=
                                                                          0 &&
                                                                      e.rating <
                                                                          1)
                                                                  .toList()
                                                                  .length /
                                                              comments.length,
                                                      backgroundColor:
                                                          const Color(
                                                              0xffDADADA),
                                                      valueColor:
                                                          const AlwaysStoppedAnimation<
                                                                  Color>(
                                                              ColorPalette
                                                                  .primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      minHeight: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                constraints:
                                    const BoxConstraints(maxHeight: 300),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: comments
                                      .map((e) => CommentWidget(
                                          comment: e, isOwner: _isOwner))
                                      .toList(),
                                ))
                          ],
                        );
                      } else {
                        print(snapshot.data);
                        return Container();
                      }
                    }),
                if (!_isOwner)
                  BorderContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rating for this room',
                          style: TextStyles.detailTitle,
                        ),
                        const Gap(5),
                        Container(
                          alignment: Alignment.center,
                          child: RatingBar.builder(
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 60,
                            unratedColor: ColorPalette.primaryColor,
                            itemBuilder: (context, index) {
                              if (index < rating) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                );
                              } else {
                                return const Icon(
                                  Icons.star_border_outlined,
                                );
                              }
                            },
                            onRatingUpdate: (double newRating) {
                              setState(() {
                                rating = newRating;
                              });
                            },
                          ),
                        ),
                        const Gap(5),
                        const Text(
                          'Write your review:',
                          style: TextStyles.detailTitle,
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            maxLines: null,
                            controller: _commentTextController,
                            validator: _detailRoomPresenter?.validateComment,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            textAlign: TextAlign.justify,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: ColorPalette.primaryColor,
                                ),
                              ),
                              hintText: 'Write your review',
                              hintStyle: TextStyles.descriptionRoom.copyWith(
                                  color:
                                      ColorPalette.rankText.withOpacity(0.5)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: ColorPalette.rankText.withOpacity(0.1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Gap(10),
                        Container(
                          alignment: Alignment.center,
                          child: ModelButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _detailRoomPresenter?.postCommentButtonPressed(
                                    widget.room.roomId,
                                    _commentTextController.text,
                                    rating);
                              }
                            },
                            name: 'POST',
                            color: ColorPalette.primaryColor.withOpacity(0.75),
                            width: 150,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Gap(15),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget imageIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      alignment: Alignment.center,
      child: Icon(
        FontAwesomeIcons.solidCircle,
        size: 9,
        color: isActive ? const Color(0xffE5E5E5) : ColorPalette.detailBorder,
      ),
    );
  }

  @override
  void onCommentPosted() {
    _commentTextController.clear();
    rating = 0;
    setState(() {});
  }

  @override
  void updateView(String? userName, bool? isOwner, String? userAvatarUrl,
      String? email, String? rentalId) {
    setState(() {
      _isOwner = isOwner ?? true;
      _rentalID = rentalId ?? "";
    });
  }

  @override
  void onGetRental(Rental? rental) {
    setState(() {
      _rental = rental;
      _rentalID = rental?.rentalID ?? "";
    });
  }

  @override
  void onSetReceiptStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  @override
  void onGetTenant(Users? user) {
    setState(() {
      _user = user;
    });
  }

  @override
  void onLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  void onPop() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void onRoutingToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  @override
  void onDeleteRoomSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Xoá phòng trọ thành công!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
  }

  @override
  void onDeleteRoomFailed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Xoá phòng trọ thất bại!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
  }
}
