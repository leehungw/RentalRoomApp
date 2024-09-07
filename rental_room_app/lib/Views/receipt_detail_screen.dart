import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:rental_room_app/Models/Receipt/receipt_model.dart';
import 'package:rental_room_app/Models/Rental/rental_model.dart';
import 'package:rental_room_app/Models/Rental/rental_repo.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Models/User/user_model.dart';
import 'package:rental_room_app/Views/list_notification_screen.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/border_container.dart';
import 'package:rental_room_app/widgets/model_button.dart';

class ReceiptDetailScreen extends StatefulWidget {
  Receipt receipt;
  Room room;
  ReceiptDetailScreen({super.key, required this.receipt, required this.room});

  @override
  State<ReceiptDetailScreen> createState() => _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends State<ReceiptDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RentalRepository _rentalRepository = RentalRepositoryIml();

  late String status;
  Users? user;
  Rental? rental;
  late double total;

  @override
  void initState() {
    super.initState();
    _loadTenant();
    _changeIsRead();
    total = widget.room.price.roomPrice +
        widget.room.price.othersPrice +
        widget.room.price.waterPrice * widget.receipt.waterIndex +
        widget.room.price.electricPrice * widget.receipt.electricIndex;
    status = widget.receipt.status ? 'Paid' : 'Unpaid';
  }

  Future<void> _changeIsRead() async {
    await _firestore
        .collection('Receipts')
        .doc(widget.receipt.receiptID)
        .update({'isRead': true});
  }

  Future<void> _updateStatus() async {
    await _firestore
        .collection('Receipts')
        .doc(widget.receipt.receiptID)
        .update({'status': true});
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListNotificationScreen(),
      ),
    );
  }

  Future<void> _loadTenant() async {
    DocumentSnapshot docUser =
        await _firestore.collection('users').doc(widget.receipt.tenantID).get();
    if (docUser.exists) {
      setState(() {
        user = Users.fromFirestore(docUser);
      });
    }
    _rentalRepository
        .getRentalData(widget.receipt.tenantID, widget.room.roomId)
        .then((value) {
      setState(() {
        rental = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette.primaryColor,
        leading: SizedBox(
          width: double.infinity,
          child: InkWell(
            customBorder: const CircleBorder(),
            onHighlightChanged: (param) {},
            splashColor: ColorPalette.primaryColor,
            onTap: () {
              Navigator.of(context).pop();
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
        title: Text('RECEIPT DETAIL',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: Text(
                DateFormat.MMMM('en_US').format(widget.receipt.createdDay),
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
                              (rental?.duration.toString() ?? '12') + ' months',
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
                              (rental?.deposit.toStringAsFixed(0) ??
                                      '1000000') +
                                  ' VNĐ',
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
                                  widget.room.price.roomPrice.toString(),
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
                                  widget.room.price.waterPrice.toString(),
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
                                  widget.room.price.electricPrice.toString(),
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
                                  widget.room.price.othersPrice.toString(),
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
                                text: const TextSpan(
                                  text: 'Room',
                                  style: TextStyles.roomProps,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.room.price.roomPrice.toString(),
                                style: TextStyles.descriptionRoom,
                                textAlign: TextAlign.justify,
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
                                text: const TextSpan(
                                  text: 'Water',
                                  style: TextStyles.roomProps,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.receipt.waterIndex.toString(),
                                style: TextStyles.descriptionRoom,
                                textAlign: TextAlign.justify,
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
                                text: const TextSpan(
                                  text: 'Electric',
                                  style: TextStyles.roomProps,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.receipt.electricIndex.toString(),
                                style: TextStyles.descriptionRoom,
                                textAlign: TextAlign.justify,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 65,
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Other',
                                  style: TextStyles.roomProps,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.room.price.others.toString(),
                                style: TextStyles.descriptionRoom,
                                textAlign: TextAlign.justify,
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
                      ],
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
                  const Gap(7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Receipt Status:',
                        style: TextStyles.receiptStatus,
                      ),
                      Text(
                        status,
                        style:
                            TextStyles.descriptionRoom.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(20),
            if (status == 'Unpaid')
              Container(
                alignment: Alignment.center,
                child: ModelButton(
                  onTap: () async {
                    _updateStatus();
                    setState(() {
                      status = 'Paid';
                    });
                  },
                  name: 'Paid The Bill',
                  color: ColorPalette.primaryColor.withOpacity(0.75),
                  width: 180,
                ),
              ),
            const Gap(30),
          ],
        ),
      ),
    );
  }
}
