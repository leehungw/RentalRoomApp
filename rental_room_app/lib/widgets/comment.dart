import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rental_room_app/Models/Comment/comment_model.dart';
import 'package:rental_room_app/Models/Reply/reply_model.dart';
import 'package:rental_room_app/Models/Reply/reply_repo.dart';
import 'package:rental_room_app/Models/User/user_model.dart';
import 'package:rental_room_app/Models/User/user_repo.dart';
import 'package:rental_room_app/config/asset_helper.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/reply.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final bool isOwner;
  const CommentWidget(
      {super.key, required this.comment, required this.isOwner});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final UserRepository _userRepository = UserRepositoryIml();
  final ReplyRepository _replyRepository = ReplyRepositoryIml();

  final _replyContentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isReplyVisible = false;
  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');
    final formattedDate = formatter.format(widget.comment.time);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: ColorPalette.detailBorder.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: FutureBuilder(
            future: Future.wait([
              _userRepository.getUserById(widget.comment.userId),
              _replyRepository
                  .getAllRepliesByCommentId(widget.comment.commentId)
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Reply> replies = snapshot.data![1] as List<Reply>;
                replies.sort((a, b) => a.time.compareTo(b.time));
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      (snapshot.data?[0] as Users).userName,
                                      style: TextStyles.h5,
                                    ),
                                    const Gap(10),
                                    Container(
                                      alignment: Alignment.center,
                                      child: RatingBar.builder(
                                        ignoreGestures: true,
                                        initialRating: widget.comment.rating,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 15,
                                        unratedColor: ColorPalette.primaryColor,
                                        itemBuilder: (context, index) {
                                          if (index < widget.comment.rating) {
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
                                        onRatingUpdate: (double value) {},
                                      ),
                                    ),
                                    const Gap(5),
                                  ],
                                ),
                                FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      widget.comment.content,
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
                      const Gap(3),
                      widget.isOwner
                          ? Padding(
                              padding: const EdgeInsets.only(left: 60),
                              child: RichText(
                                  text: TextSpan(
                                      text: "Reply",
                                      style: TextStyles.h6.copyWith(
                                          fontFamily:
                                              GoogleFonts.ntr().fontFamily,
                                          color: ColorPalette.greenText),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          isReplyVisible = !isReplyVisible;
                                          setState(() {});
                                        })),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50,
                          right: 10,
                        ),
                        child: Visibility(
                            visible: isReplyVisible,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    maxLines: null,
                                    controller: _replyContentController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please type something!";
                                      }
                                      return null;
                                    },
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
                                      hintStyle: TextStyles.descriptionRoom
                                          .copyWith(
                                              color: ColorPalette.rankText
                                                  .withOpacity(0.5)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: ColorPalette.rankText
                                              .withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(4),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: RichText(
                                      text: TextSpan(
                                          text: "Post",
                                          style: TextStyles.h6.copyWith(
                                              fontFamily:
                                                  GoogleFonts.ntr().fontFamily,
                                              color: ColorPalette.greenText),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                Reply reply = Reply(
                                                    commentId: widget
                                                        .comment.commentId,
                                                    userId: FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
                                                    content:
                                                        _replyContentController
                                                            .text,
                                                    time: DateTime.now());
                                                _replyRepository
                                                    .uploadReply(reply);
                                                _replyContentController.clear();
                                                isReplyVisible = false;
                                                setState(() {});
                                              }
                                            })),
                                ),
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: replies
                              .map((e) => ReplyWidget(reply: e))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }
}
