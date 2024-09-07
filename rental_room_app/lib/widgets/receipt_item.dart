import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:rental_room_app/Models/Receipt/receipt_model.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Models/Room/room_repo.dart';
import 'package:rental_room_app/Views/receipt_detail_screen.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/border_container.dart';

class ReceiptItem extends StatefulWidget {
  Receipt receipt;
  ReceiptItem({super.key, required this.receipt});

  @override
  State<ReceiptItem> createState() => _ReceiptItemState();
}

class _ReceiptItemState extends State<ReceiptItem> {
  late Room room;
  bool isLoading = true;
  double total = 0;
  String status = 'Unpaid';

  @override
  void initState() {
    super.initState();
    _loadRoom();
  }

  Future<void> _loadRoom() async {
    room = await RoomRepositoryIml().getRoomById(widget.receipt.roomID);
    setState(() {
      isLoading = false;
      total = room.price.roomPrice +
          room.price.othersPrice +
          room.price.waterPrice * widget.receipt.waterIndex +
          room.price.electricPrice * widget.receipt.electricIndex;
      status = widget.receipt.status ? 'Paid' : 'Unpaid';
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
            child: CircularProgressIndicator(
              color: ColorPalette.primaryColor,
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReceiptDetailScreen(
                    receipt: widget.receipt,
                    room: room,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
              decoration: BoxDecoration(
                color: widget.receipt.isRead
                    ? Colors.transparent
                    : Colors.blue.withOpacity(0.15),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: BorderContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat.MMMM('en_US')
                              .format(widget.receipt.createdDay),
                          style: TextStyles.monthStyle.copyWith(fontSize: 18),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(widget.receipt.createdDay),
                          style: TextStyles.descriptionRoom,
                        ),
                      ],
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
                          'VND',
                          style: TextStyles.descriptionRoom,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                    const Gap(5),
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
                              widget.receipt.waterIndex.toString(),
                              style: TextStyles.descriptionRoom,
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                        const Text(
                          'm3',
                          style: TextStyles.descriptionRoom,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                    const Gap(5),
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
                              widget.receipt.electricIndex.toString(),
                              style: TextStyles.descriptionRoom,
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                        const Text(
                          'kWh',
                          style: TextStyles.descriptionRoom,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                    const Gap(5),
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
                          'VND',
                          style: TextStyles.descriptionRoom,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                    const Gap(5),
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
                    const Gap(5),
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
            ),
          );
  }
}
