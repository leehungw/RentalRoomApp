import 'package:flutter/material.dart';
import 'package:rental_room_app/Models/Receipt/receipt_model.dart';
import 'package:rental_room_app/Models/Receipt/receipt_repo.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/widgets/receipt_item.dart';

class NotificationView extends StatelessWidget {
  final bool isOwner;
  final ReceiptRepository _receiptRepository = ReceiptRepositoryIml();

  NotificationView({
    Key? key,
    required this.isOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isOwner
        ? Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              height: 64,
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
                  final receipts = snapshot.data!;
                  return ListView(
                    children:
                        receipts.map((e) => ReceiptItem(receipt: e)).toList(),
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
  }
}
