import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/Views/Home/Subviews/filter_container_widget.dart';

class AllRoom extends StatefulWidget {
  const AllRoom({super.key});
  static const String routeName = "all_room";

  @override
  State<AllRoom> createState() => _AllRoomState();
}

class _AllRoomState extends State<AllRoom> {
  String? searchValue;
  bool isVisibleFilter = false;
  @override
  Widget build(BuildContext context) {
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
        title: Text('ROOMS',
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
      body: Container(
        padding: const EdgeInsets.all(20),
        color: ColorPalette.backgroundColor,
        child: Column(
          children: [
            const Gap(36),
            SizedBox(
              height: 42,
              width: double.infinity,
              child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchValue = value;
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
            const Gap(20),
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
                          onTapIconDown: () {},
                          onTapIconUp: () {},
                        ),
                        FilterContainerWidget(
                          name: 'Distance',
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
                          onTapIconDown: () {},
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
                        FilterContainerWidget(
                          name: 'Kind',
                          icon1: const Icon(
                            FontAwesomeIcons.angleDown,
                            color: ColorPalette.primaryColor,
                            size: 10,
                          ),
                          onTapIconDown: () {},
                        ),
                      ],
                    ),
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
