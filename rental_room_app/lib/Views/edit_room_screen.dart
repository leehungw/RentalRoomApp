import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_room_app/Contract/edit_room_contract.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Presenter/edit_room_presenter.dart';
import 'package:rental_room_app/Views/home_screen.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/model_button.dart';

class EditRoomScreen extends StatefulWidget {
  Room room;
  EditRoomScreen({super.key, required this.room});

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen>
    implements EditRoomContract {
  EditRoomPresenter? _editRoomPresenter;
  final _formKey = GlobalKey<FormState>();

  final List<String> _roomKinds = <String>[
    'Standard Room',
    'Loft Room',
    'House'
  ];

  //
  //Params Controllers
  //

  final _roomIdController = TextEditingController();
  String _roomKind = '';
  final _areaController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _roomPriceController = TextEditingController();
  final _waterPriceController = TextEditingController();
  final _electricPriceController = TextEditingController();
  final _otherControler = TextEditingController();
  final _facebookController = TextEditingController();
  final _addressController = TextEditingController();

  final List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _roomKind = _roomKinds.first;
    _roomIdController.text = widget.room.roomName;
    _editRoomPresenter = EditRoomPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        title: Text('EDIT ROOM',
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
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                const Text(
                  'Room Information',
                  style: TextStyles.detailTitle,
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Room name',
                          style: TextStyles.roomProps,
                          children: [
                            TextSpan(
                                text: ' *',
                                style: TextStyles.roomProps
                                    .copyWith(color: ColorPalette.redColor))
                          ]),
                    ),
                    SizedBox(
                      width: size.width - 150,
                      child: TextFormField(
                        enabled: false,
                        controller: _roomIdController,
                        validator: _editRoomPresenter?.validateRoomName,
                        cursorColor: Colors.black,
                        style: TextStyles.roomPropsContent,
                        scrollPadding: const EdgeInsets.all(0),
                        maxLines: null,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        textAlign: TextAlign.justify,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorPalette.detailBorder,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 0,
                            right: 0,
                            top: 5,
                            bottom: 0,
                          ),
                          hintStyle: TextStyles.descriptionRoom.copyWith(
                              color: ColorPalette.rankText.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Kind',
                          style: TextStyles.roomProps,
                          children: [
                            TextSpan(
                                text: ' *',
                                style: TextStyles.roomProps
                                    .copyWith(color: ColorPalette.redColor))
                          ]),
                    ),
                    SizedBox(
                      width: size.width - 150,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _roomKind,
                        elevation: 16,
                        style: TextStyles.roomPropsContent,
                        underline: Container(
                          height: 1,
                          color: ColorPalette.detailBorder,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _roomKind = value!;
                          });
                        },
                        items:
                            _roomKinds.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const Gap(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Area',
                          style: TextStyles.roomProps,
                          children: [
                            TextSpan(
                                text: ' *',
                                style: TextStyles.roomProps
                                    .copyWith(color: ColorPalette.redColor))
                          ]),
                    ),
                    SizedBox(
                      width: size.width - 150,
                      child: TextFormField(
                        controller: _areaController,
                        validator: _editRoomPresenter?.validateArea,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.black,
                        style: TextStyles.roomPropsContent,
                        scrollPadding: const EdgeInsets.all(0),
                        maxLines: null,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        textAlign: TextAlign.justify,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorPalette.detailBorder,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 0,
                            right: 0,
                            top: 5,
                            bottom: 0,
                          ),
                          hintText: 'Example: 60',
                          hintStyle: TextStyles.descriptionRoom.copyWith(
                              color: ColorPalette.rankText.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Location',
                          style: TextStyles.roomProps,
                          children: [
                            TextSpan(
                                text: ' *',
                                style: TextStyles.roomProps
                                    .copyWith(color: ColorPalette.redColor))
                          ]),
                    ),
                    SizedBox(
                      width: size.width - 150,
                      child: TextFormField(
                        controller: _locationController,
                        validator: _editRoomPresenter?.validateLocation,
                        cursorColor: Colors.black,
                        style: TextStyles.roomPropsContent,
                        scrollPadding: const EdgeInsets.all(0),
                        maxLines: null,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        textAlign: TextAlign.justify,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorPalette.detailBorder,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 0,
                            right: 0,
                            top: 5,
                            bottom: 0,
                          ),
                          hintText:
                              'Example: 43 Tan Lap, Dong Hoa, Di An, Binh Duong',
                          hintStyle: TextStyles.descriptionRoom.copyWith(
                              color: ColorPalette.rankText.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(15),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                        text: 'Description',
                        style: TextStyles.roomProps,
                        children: [
                          TextSpan(
                              text: ' *',
                              style: TextStyles.roomProps
                                  .copyWith(color: ColorPalette.redColor))
                        ]),
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  validator: _editRoomPresenter?.validateDescription,
                  cursorColor: Colors.black,
                  style: TextStyles.roomPropsContent,
                  scrollPadding: const EdgeInsets.all(0),
                  maxLines: null,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorPalette.detailBorder,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorPalette.primaryColor,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 0,
                      bottom: 13,
                    ),
                    hintText: 'Example: A beautiful room with full furniture',
                    hintStyle: TextStyles.descriptionRoom.copyWith(
                        color: ColorPalette.rankText.withOpacity(0.5)),
                  ),
                ),
                const Gap(10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                        text: 'Pictures',
                        style: TextStyles.roomProps,
                        children: [
                          TextSpan(
                              text: ' *',
                              style: TextStyles.roomProps
                                  .copyWith(color: ColorPalette.redColor))
                        ]),
                  ),
                ),
                const Gap(10),
                FormField(
                    validator: _editRoomPresenter?.validateImage,
                    builder: (FormFieldState<List<String>?> state) {
                      return InputDecorator(
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            helperText: "",
                            errorText: state.errorText,
                          ),
                          child: Column(children: [
                            GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              mainAxisSpacing: 5.0,
                              crossAxisSpacing: 5.0,
                              children: List.generate(
                                _images.length,
                                (index) {
                                  return Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Image(
                                          image:
                                              FileImage(File(_images[index])),
                                          height: size.width / 2 - 20,
                                          width: size.width / 2 - 20,
                                        ),
                                      ),
                                      Positioned(
                                        top: 10.0,
                                        right: 10.0,
                                        child: IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            setState(() {
                                              _images.removeAt(index);
                                            });
                                            state.didChange(_images);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const Gap(10),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  _editRoomPresenter?.selectImageFromGallery();
                                  state.didChange(_images);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 250,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: ColorPalette.detailBorder
                                          .withOpacity(0.1),
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                  ),
                                  child: const Text('Upload Here'),
                                ),
                              ),
                            ),
                          ]));
                    }),
                const Gap(30),
                const Text(
                  'Price',
                  style: TextStyles.detailTitle,
                ),
                const Gap(10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: null,
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: 'Room',
                              style: TextStyles.roomProps,
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyles.roomProps
                                        .copyWith(color: ColorPalette.redColor))
                              ]),
                        ),
                      ),
                      const Gap(1),
                      SizedBox(
                        width: size.width - 215,
                        child: TextFormField(
                          controller: _roomPriceController,
                          validator: _editRoomPresenter?.validateRoomPrice,
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
                        width: null,
                        alignment: Alignment.centerRight,
                        child: const Text(
                          'VND/Month',
                          style: TextStyles.roomPropsContent,
                        ),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: null,
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: 'Water',
                              style: TextStyles.roomProps,
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyles.roomProps
                                        .copyWith(color: ColorPalette.redColor))
                              ]),
                        ),
                      ),
                      SizedBox(
                        width: size.width - 200,
                        child: TextFormField(
                          controller: _waterPriceController,
                          validator: _editRoomPresenter?.validateWaterPrice,
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
                        width: null,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'VND/m3',
                          style: TextStyles.roomPropsContent,
                        ),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: null,
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: 'Electric',
                              style: TextStyles.roomProps,
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyles.roomProps
                                        .copyWith(color: ColorPalette.redColor))
                              ]),
                        ),
                      ),
                      SizedBox(
                        width: size.width - 200,
                        child: TextFormField(
                          controller: _electricPriceController,
                          validator: _editRoomPresenter?.validateElectricPrice,
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
                        width: null,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'VND/kWh',
                          style: TextStyles.roomPropsContent,
                        ),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: null,
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: 'Other',
                              style: TextStyles.roomProps,
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyles.roomProps
                                        .copyWith(color: ColorPalette.redColor))
                              ]),
                        ),
                      ),
                      const Gap(1),
                      SizedBox(
                        width: size.width - 215,
                        child: TextFormField(
                          controller: _otherControler,
                          validator: _editRoomPresenter?.validateOtherPrice,
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
                        width: null,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'VND/Month',
                          style: TextStyles.roomPropsContent,
                        ),
                      ),
                    ]),
                const Gap(30),
                const Text(
                  'Additional Owner Information',
                  style: TextStyles.detailTitle,
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Facebook',
                      style: TextStyles.roomProps,
                    ),
                    SizedBox(
                      width: size.width - 140,
                      child: TextFormField(
                        controller: _facebookController,
                        validator: _editRoomPresenter?.validateFacebook,
                        keyboardType: TextInputType.url,
                        cursorColor: Colors.black,
                        style: TextStyles.roomPropsContent,
                        scrollPadding: const EdgeInsets.all(0),
                        maxLines: null,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        textAlign: TextAlign.justify,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorPalette.detailBorder,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 0,
                            right: 0,
                            top: 5,
                            bottom: 0,
                          ),
                          hintText:
                              'Example: https://www.facebook.com/nguyenchutro',
                          hintStyle: TextStyles.descriptionRoom.copyWith(
                              color: ColorPalette.rankText.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Address',
                          style: TextStyles.roomProps,
                          children: [
                            TextSpan(
                                text: ' *',
                                style: TextStyles.roomProps
                                    .copyWith(color: ColorPalette.redColor))
                          ]),
                    ),
                    SizedBox(
                      width: size.width - 140,
                      child: TextFormField(
                        controller: _addressController,
                        validator: _editRoomPresenter?.validateAddress,
                        cursorColor: Colors.black,
                        style: TextStyles.roomPropsContent,
                        scrollPadding: const EdgeInsets.all(0),
                        maxLines: null,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        textAlign: TextAlign.justify,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorPalette.detailBorder,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 0,
                            right: 0,
                            top: 5,
                            bottom: 0,
                          ),
                          hintText:
                              'Example: 43 Tan Lap, Dong Hoa, Di An, Binh Duong',
                          hintStyle: TextStyles.descriptionRoom.copyWith(
                              color: ColorPalette.rankText.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(45),
                Container(
                  alignment: Alignment.center,
                  child: ModelButton(
                    name: 'SAVE',
                    onTap: () {
                      //TODO: save room
                      if (_formKey.currentState!.validate()) {
                        _editRoomPresenter?.saveButtonPressed(
                            widget.room.roomId,
                            _roomIdController.text,
                            _roomKind,
                            _areaController.text,
                            _locationController.text,
                            _descriptionController.text,
                            _images,
                            _roomPriceController.text,
                            _waterPriceController.text,
                            _electricPriceController.text,
                            _otherControler.text,
                            _facebookController.text,
                            _addressController.text);
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
        ),
      ),
    );
  }

  @override
  void onChangeProfilePicture(String pickedImage) {
    setState(() {
      _images.add(pickedImage);
    });
  }

  @override
  void onEditFailed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Không thể chỉnh sửa thông tin phòng! Vui lòng thử lại sau!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
  }

  @override
  void onEditSucceeded() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Thông tin phòng đã được chỉnh sửa thành công!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
  }

  @override
  void onPopContext() {
    Navigator.of(context, rootNavigator: true).pop();
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
}
