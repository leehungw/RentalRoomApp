import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rental_room_app/Contract/YourRoom/new_receipt_contract.dart';
import 'package:rental_room_app/Models/Rental/rental_model.dart';
import 'package:rental_room_app/Models/Rental/rental_repo.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Models/User/user_model.dart';
import 'package:rental_room_app/Presenter/YourRoom/new_receipt_presenter.dart';
import 'package:rental_room_app/Views/Home/home_screen.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/border_container.dart';
import 'package:rental_room_app/widgets/model_button.dart';

class NewReceipt extends StatefulWidget {
  Room room;
  String tenantID;
  NewReceipt({super.key, required this.room, required this.tenantID});
  
  @override
  State<NewReceipt> createState() => _NewReceiptState();
}

class _NewReceiptState extends State<NewReceipt> implements NewReceiptContract {
  NewReceiptPresenter? _newReceiptPresenter;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RentalRepository _rentalRepository = RentalRepositoryIml();

  final _roomPriceController = TextEditingController();
  final _waterPriceController = TextEditingController();
  final _electricPriceController = TextEditingController();
  final _otherControler = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime now1 = DateTime.now();
  //String currentMonthName = DateFormat.MMMM('en_US').format(now1);

  Users? user;
  Rental? rental;
  late double total;

  @override
  void initState() {
    super.initState();
    _newReceiptPresenter = NewReceiptPresenter(this);
    _loadTenant();
    _roomPriceController.text = widget.room.price.roomPrice.toString();
    _otherControler.text = widget.room.price.othersPrice.toString();
    total = (widget.room.price.roomPrice + widget.room.price.othersPrice)
        .toDouble();
  }

  Future<void> _loadTenant() async {
    DocumentSnapshot docUser =
        await _firestore.collection('users').doc(widget.tenantID).get();
    if (docUser.exists) {
      setState(() {
        user = Users.fromFirestore(docUser);
      });
    }

    try {
    _rentalRepository
        .getRentalData(widget.tenantID, widget.room.roomId)
        .then((value) {
      setState(() {
        rental = value;
      });
    });
    } catch (e){
      print("===========Error load tennant new receipt");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Room room = widget.room;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette.primaryColor,
        // leadingWidth: kDefaultIconSize * 3,
        leading: SizedBox(
          width: double.infinity,
          child: InkWell(
            customBorder: const CircleBorder(),
            onHighlightChanged: (param) {},
            splashColor: ColorPalette.primaryColor,
            onTap: () {
              context.pop();
            },
            child: const Icon(
              FontAwesomeIcons.arrowLeft,
              color: ColorPalette.backgroundColor,
              shadows: [
                Shadow(
                    color: Colors.black12, offset: Offset(3, 6), blurRadius: 6)
              ],
            ),
          ),
        ),
        title: Text('NEW RECEIPT',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: Text(
                DateFormat.MMMM('en_US').format(now1),
                style: TextStyles.monthStyle,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              user?.getUserName ?? 'Nguyen Nguoi Thue',
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
                              user?.getGender ?? 'Male',
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
                              user?.getPhone ?? '0123456789',
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
                              rental?.identity ?? '123456789',
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
                              user?.getEmail ?? 'abcde@gmail.com',
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
                                  user?.getBirthday ??
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
                              rental?.numberPeople.toString() ?? '1',
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
                              '${rental?.duration.toString() ?? '12'} months',
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
                              '${rental?.deposit.toStringAsFixed(0) ??
                                      '1000000'} VNĐ',
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
                              rental?.facebook ?? 'https://www.facebook.com',
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
                                FontAwesomeIcons.houseChimney,
                                size: 15,
                                color: ColorPalette.primaryColor,
                              ),
                            ),
                            Text(
                              widget.room.roomName ?? 'Z00',
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
                  const Gap(20),
                  Form(
                    key: _formKey,
                    child: BorderContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bill',
                            style: TextStyles.detailTitle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 65,
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Room',
                                      style: TextStyles.roomProps,
                                      children: [
                                        TextSpan(
                                            text: ' *',
                                            style: TextStyles.roomProps
                                                .copyWith(
                                                    color:
                                                        ColorPalette.redColor))
                                      ]),
                                ),
                              ),
                              SizedBox(
                                width: size.width - 200,
                                child: TextFormField(
                                  enabled: false,
                                  controller: _roomPriceController,
                                  validator:
                                      _newReceiptPresenter?.validateRoomPrice,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.black,
                                  style: TextStyles.roomPropsContent,
                                  scrollPadding: const EdgeInsets.all(0),
                                  maxLines: null,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  textAlign: TextAlign.justify,
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorPalette.detailBorder,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorPalette.primaryColor,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                      left: 5,
                                      right: 0,
                                      top: 5,
                                      bottom: 0,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                alignment: Alignment.centerRight,
                                child: const Text(
                                  'VND',
                                  style: TextStyles.roomPropsContent,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 65,
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Other',
                                      style: TextStyles.roomProps,
                                      children: [
                                        TextSpan(
                                            text: ' *',
                                            style: TextStyles.roomProps
                                                .copyWith(
                                                    color:
                                                        ColorPalette.redColor))
                                      ]),
                                ),
                              ),
                              SizedBox(
                                width: size.width - 200,
                                child: TextFormField(
                                  enabled: false,
                                  controller: _otherControler,
                                  validator:
                                      _newReceiptPresenter?.validateOtherPrice,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.black,
                                  style: TextStyles.roomPropsContent,
                                  scrollPadding: const EdgeInsets.all(0),
                                  maxLines: null,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  textAlign: TextAlign.justify,
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorPalette.detailBorder,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorPalette.primaryColor,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                      left: 5,
                                      right: 0,
                                      top: 5,
                                      bottom: 0,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                alignment: Alignment.centerRight,
                                child: const Text(
                                  'VND',
                                  style: TextStyles.roomPropsContent,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 65,
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Water',
                                      style: TextStyles.roomProps,
                                      children: [
                                        TextSpan(
                                            text: ' *',
                                            style: TextStyles.roomProps
                                                .copyWith(
                                                    color:
                                                        ColorPalette.redColor))
                                      ]),
                                ),
                              ),
                              SizedBox(
                                width: size.width - 200,
                                child: TextFormField(
                                  onFieldSubmitted: (value) {
                                    setState(() {
                                      total += double.parse(value) *
                                          widget.room.price.water;
                                    });
                                  },
                                  controller: _waterPriceController,
                                  validator:
                                      _newReceiptPresenter?.validateWaterPrice,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.black,
                                  style: TextStyles.roomPropsContent,
                                  scrollPadding: const EdgeInsets.all(0),
                                  maxLines: null,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  textAlign: TextAlign.justify,
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorPalette.detailBorder,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorPalette.primaryColor,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                      left: 5,
                                      right: 0,
                                      top: 5,
                                      bottom: 0,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                alignment: Alignment.centerRight,
                                child: const Text(
                                  'm3',
                                  style: TextStyles.roomPropsContent,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 65,
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Electric',
                                      style: TextStyles.roomProps,
                                      children: [
                                        TextSpan(
                                            text: ' *',
                                            style: TextStyles.roomProps
                                                .copyWith(
                                                    color:
                                                        ColorPalette.redColor))
                                      ]),
                                ),
                              ),
                              SizedBox(
                                width: size.width - 200,
                                child: TextFormField(
                                  onFieldSubmitted: (value) {
                                    setState(() {
                                      total += double.parse(value) *
                                          widget.room.price.electric;
                                    });
                                  },
                                  controller: _electricPriceController,
                                  validator: _newReceiptPresenter
                                      ?.validateElectricPrice,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.black,
                                  style: TextStyles.roomPropsContent,
                                  scrollPadding: const EdgeInsets.all(0),
                                  maxLines: null,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  textAlign: TextAlign.justify,
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorPalette.detailBorder,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorPalette.primaryColor,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                      left: 5,
                                      right: 0,
                                      top: 5,
                                      bottom: 0,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                alignment: Alignment.centerRight,
                                child: const Text(
                                  'kWh',
                                  style: TextStyles.roomPropsContent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL',
                        style: TextStyles.total,
                      ),
                      Text(
                        '$total VND',
                        style: TextStyles.total,
                      ),
                    ],
                  ),
                  const Gap(15),
                  Container(
                    alignment: Alignment.center,
                    child: ModelButton(
                      name: 'SEND',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _newReceiptPresenter?.sendButtonPressed(
                              widget.tenantID,
                              widget.room.ownerId,
                              widget.room.roomId,
                              false,
                              false,
                              now1,
                              _waterPriceController.text,
                              _electricPriceController.text);
                        }
                      },
                      width: 150,
                      color: ColorPalette.primaryColor.withOpacity(0.75),
                    ),
                  ),
                  const Gap(10),
                  Container(
                    alignment: Alignment.center,
                    child: ModelButton(
                      name: 'CANCEL',
                      onTap: () {
                        context.pop();
                      },
                      width: 150,
                      color: ColorPalette.redColor,
                    ),
                  ),
                  const Gap(50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onCreateSucceeded() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Send Receipt succeeded!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  @override
  void onCreateFailed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Cannot Rental This Room! Please try again later!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
  }

  @override
  void onWaitingProgressBar() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  void onPopContext() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
