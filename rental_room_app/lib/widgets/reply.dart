import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:rental_room_app/Models/Reply/reply_model.dart';
import 'package:rental_room_app/Models/User/user_repo.dart';
import 'package:rental_room_app/config/asset_helper.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';

class ReplyWidget extends StatefulWidget {
  final Reply reply;
  const ReplyWidget({super.key, required this.reply});

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  final UserRepository _userRepository = UserRepositoryIml();
  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');
    final formattedDate = formatter.format(widget.reply.time);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder(
          future: _userRepository.getUserById(widget.reply.userId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(AssetHelper.avatar),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                snapshot.data!.userName,
                                style: TextStyles.h5,
                              ),
                              const Gap(5),
                            ],
                          ),
                          FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                widget.reply.content,
                                style: TextStyles.h6,
                              )),
                          const Gap(2),
                          Text(
                            formattedDate,
                            style: TextStyles.h6.copyWith(
                                color: ColorPalette.detailBorder,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
