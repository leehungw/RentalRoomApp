import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rental_room_app/Models/Comment/comment_model.dart';
import 'package:rental_room_app/Models/Comment/comment_repo.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Views/YourRoom/detail_room_screen.dart';
import 'package:rental_room_app/config/asset_helper.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';

class RoomItem extends StatefulWidget {
  Room room;
  RoomItem({super.key, required this.room});

  @override
  State<RoomItem> createState() => _RoomItemState();
}

class _RoomItemState extends State<RoomItem> {
  double? _distance;

  final _commentRepo = CommentRepositoryIml();

  @override
  void initState() {
    super.initState();
    _calculateDistance();
  }

  Future<void> _calculateDistance() async {
    try {
      // Lấy vị trí hiện tại của thiết bị
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Chuyển đổi địa chỉ của phòng thành tọa độ
      List<Location> locations =
          await locationFromAddress(widget.room.location);
      if (locations.isNotEmpty) {
        double distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          locations.first.latitude,
          locations.first.longitude,
        );

        setState(() {
          _distance = distanceInMeters / 1000; // Chuyển đổi sang km
        });
      }
    } catch (e) {
      print("Error calculating distance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailRoomScreen(
              room: widget.room,
            ),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: ColorPalette.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorPalette.grayText),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                widget.room.primaryImgUrl,
                width: double.infinity,
                height: 105,
                fit: BoxFit.fitWidth,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Container(
                    height: 105,
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            maxLines: 1,
                            widget.room.roomName,
                            style: TextStyles.nameRoomItem,
                          ),
                        ),
                        Expanded(child: Container()),
                        const Icon(
                          Icons.location_pin,
                          size: 20,
                        ),
                        if (_distance != null)
                          Text(
                            '${_distance!.toStringAsFixed(1)} km',
                            style: TextStyles.desFunction,
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(AssetHelper.iconRoomKind),
                        Container(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            widget.room.kind,
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 1,
                      width: double.infinity,
                      color: ColorPalette.grayText,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$ ${widget.room.price.roomPrice}',
                          style: TextStyles.nameRoomItem.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'VNĐ/month',
                          style: TextStyles.nameRoomItem.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.square,
                          color: ColorPalette.primaryColor,
                          size: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            widget.room.area.toStringAsFixed(0),
                            style: TextStyles.nameRoomItem.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        Text(
                          'm2',
                          style: TextStyles.nameRoomItem.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder(
                        future: _commentRepo
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
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBar.builder(
                                  initialRating: avgRating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 13,
                                  unratedColor: const Color(0xffDADADA),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (value) {},
                                  ignoreGestures: true,
                                ),
                                Text(
                                  avgRating.toStringAsFixed(1),
                                  style: TextStyles.nameRoomItem.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '(${comments.length})',
                                  style: TextStyles.desFunction,
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
