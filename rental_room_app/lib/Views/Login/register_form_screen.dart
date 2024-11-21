import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rental_room_app/Contract/Login/register_form_contract.dart';
import 'package:rental_room_app/Presenter/Login/register_form_presenter.dart';
import 'package:rental_room_app/config/asset_helper.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';

// ignore: must_be_immutable
class RegisterFormScreen extends StatefulWidget {
  RegisterFormScreen({super.key, this.email});
  String? email;
  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen>
    implements RegisterFormContract {
  RegisterFormPresenter? _registerFormPresenter;
  final _formKey = GlobalKey<FormState>();
  String _imageFile = "";

  //Param Controllers
  final _phoneNumTextController = TextEditingController();
  final _fullnameTextController = TextEditingController();
  String _gender = "";
  DateTime birthday = DateTime.now();
  bool? _passwordVisible;
  bool? _confirmPasswordVisible;
  final _accountPasswordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  bool _isOwner = false;
  final _desiredPriceController = TextEditingController();
  final _desiredLocationController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  List<Map<String, dynamic>> _bankList = [];
  String? _selectedBank;
  //

  @override
  void initState() {
    super.initState();
    _registerFormPresenter = RegisterFormPresenter(this);
    _passwordVisible = true;
    _confirmPasswordVisible = true;
    _registerFormPresenter?.fetchBankList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            reverse: false,
            child: Center(
              child: Container(
                color: ColorPalette.backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(20),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            int count = 0;
                            Navigator.popUntil(context, (_) => count++ >= 2);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: ColorPalette.darkBlueText,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 55),
                          child: Text(
                            "Complete your profile",
                            style: TextStyles.h4.copyWith(
                              color: ColorPalette.darkBlueText,
                            ),
                          ),
                        )
                      ],
                    ),
                    const Gap(30),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _registerFormPresenter?.selectImageFromGallery,
                          child: Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: _imageFile.isEmpty
                                ? const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image:
                                          AssetImage(AssetHelper.defaultAvatar),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: FileImage(File(_imageFile)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: -12.0,
                          right: -12.0,
                          child: IconButton(
                            onPressed:
                                _registerFormPresenter?.selectImageFromGallery,
                            icon: const Icon(Icons.camera_alt),
                            color: ColorPalette.calendarGround,
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: TextFormField(
                              enabled: false,
                              initialValue: widget.email,
                              style: TextStyles.h5,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorPalette.bgTextFieldColor,
                                disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 10,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16)),
                                labelText: "E-Mail",
                                labelStyle: TextStyles.h5
                                    .copyWith(color: ColorPalette.rankText),
                                helperText: " ",
                              ),
                              obscureText: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _phoneNumTextController,
                              validator:
                                  _registerFormPresenter?.validatePhoneNum,
                              keyboardType: TextInputType.phone,
                              style: TextStyles.h5,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorPalette.bgTextFieldColor,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 10,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 5,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16)),
                                labelText: "Phone Number",
                                labelStyle: TextStyles.h5
                                    .copyWith(color: ColorPalette.rankText),
                                helperText: " ",
                              ),
                              obscureText: false,
                            ),
                          ),
                          const Gap(5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _fullnameTextController,
                              validator:
                                  _registerFormPresenter?.validateFullName,
                              keyboardType: TextInputType.name,
                              style: TextStyles.h5,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorPalette.bgTextFieldColor,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 10,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 5,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16)),
                                labelText: "Full Name",
                                labelStyle: TextStyles.h5
                                    .copyWith(color: ColorPalette.rankText),
                                helperText: " ",
                              ),
                              obscureText: false,
                            ),
                          ),
                          const Gap(5),
                          FormField(
                            validator: _registerFormPresenter?.validateGender,
                            builder: (FormFieldState<String?> state) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    filled: true,
                                    fillColor: ColorPalette.bgTextFieldColor,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 10,
                                            color:
                                                ColorPalette.bgTextFieldColor),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 10,
                                            color:
                                                ColorPalette.bgTextFieldColor),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 10,
                                            color:
                                                ColorPalette.bgTextFieldColor),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    labelText: "Gender",
                                    labelStyle: TextStyles.h4
                                        .copyWith(color: ColorPalette.rankText),
                                    helperText: " ",
                                    errorText: state.errorText,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      const Gap(10),
                                      Radio<String>(
                                        activeColor: ColorPalette.primaryColor,
                                        value: "Male",
                                        groupValue: _gender,
                                        onChanged: (value) {
                                          setState(() {
                                            _gender = value!;
                                          });
                                          state.didChange(_gender);
                                        },
                                      ),
                                      const Text(
                                        "Male",
                                        style: TextStyles.h5,
                                      ),
                                      const Gap(35),
                                      Radio<String>(
                                        activeColor: ColorPalette.primaryColor,
                                        value: "Female",
                                        groupValue: _gender,
                                        onChanged: (value) {
                                          setState(() {
                                            _gender = value!;
                                          });
                                          state.didChange(_gender);
                                        },
                                      ),
                                      const Text(
                                        "Female",
                                        style: TextStyles.h5,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const Gap(5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: DateTimeFormField(
                              validator:
                                  _registerFormPresenter?.validateBirthday,
                              onChanged: (DateTime? value) {
                                setState(() {
                                  birthday = value ?? DateTime.now();
                                });
                              },
                              mode: DateTimeFieldPickerMode.date,
                              style: TextStyles.h5,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorPalette.bgTextFieldColor,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 10,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 5,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16)),
                                labelText: "Birthday",
                                labelStyle: TextStyles.h5
                                    .copyWith(color: ColorPalette.rankText),
                                helperText: " ",
                              ),
                            ),
                          ),
                          const Gap(5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: TextFormField(
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                              controller: _accountPasswordTextController,
                              validator: _registerFormPresenter
                                  ?.validateAccountPassword,
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyles.h5,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorPalette.bgTextFieldColor,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 10,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 5,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16)),
                                labelText: "Account Password",
                                labelStyle: TextStyles.h5
                                    .copyWith(color: ColorPalette.rankText),
                                helperText: " ",
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible!
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                      () {
                                        _passwordVisible = !_passwordVisible!;
                                      },
                                    );
                                  },
                                ),
                              ),
                              obscureText: _passwordVisible!,
                              obscuringCharacter: '*',
                            ),
                          ),
                          const Gap(5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: TextFormField(
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                              controller: _confirmPasswordTextController,
                              validator: _registerFormPresenter
                                  ?.validateConfirmPassword,
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyles.h5,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorPalette.bgTextFieldColor,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 10,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 5,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16)),
                                labelText: "Confirm Password",
                                labelStyle: TextStyles.h5
                                    .copyWith(color: ColorPalette.rankText),
                                helperText: " ",
                                suffixIcon: IconButton(
                                  icon: Icon(_confirmPasswordVisible!
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                      () {
                                        _confirmPasswordVisible =
                                            !_confirmPasswordVisible!;
                                      },
                                    );
                                  },
                                ),
                              ),
                              obscureText: _confirmPasswordVisible!,
                              obscuringCharacter: '*',
                            ),
                          ),
                          Row(
                            children: [
                              const Gap(30),
                              Checkbox(
                                value: _isOwner,
                                onChanged: (value) =>
                                    setState(() => _isOwner = value!),
                                checkColor: ColorPalette.backgroundColor,
                                side: const BorderSide(
                                    width: 2, color: ColorPalette.blackText),
                                activeColor: ColorPalette.primaryColor,
                              ),
                              Flexible(
                                child: Text(
                                  'You are the owner of a rental property',
                                  style: TextStyles.h6.copyWith(
                                      color: ColorPalette.darkBlueText),
                                ),
                              ),
                            ],
                          ),
                          const Gap(5),
                          if (_isOwner) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "Select Bank",
                                    filled: true,
                                    fillColor: ColorPalette.bgTextFieldColor,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 10,
                                          color: ColorPalette.bgTextFieldColor),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 5,
                                          color: ColorPalette.bgTextFieldColor),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  value: _selectedBank,
                                  items: _bankList
                                      .map<DropdownMenuItem<String>>((bank) {
                                    return DropdownMenuItem<String>(
                                      value: bank['bin'],
                                      child: Row(
                                        children: [
                                          (bank['logo'] as String).isNotEmpty
                                              ? Image.network(
                                                  bank['logo'],
                                                  width: 30,
                                                  height: 30,
                                                )
                                              : const SizedBox(
                                                  height: 30, width: 30),
                                          const SizedBox(width: 10),
                                          Text(bank['shortName']),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedBank = value;
                                    });
                                  },
                                  validator: _registerFormPresenter
                                      ?.validateSelectedBank),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: TextFormField(
                                controller: _accountNumberController,
                                keyboardType: TextInputType.number,
                                style: TextStyles.h5,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: ColorPalette.bgTextFieldColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 10,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 5,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  labelText: "Account Number",
                                  labelStyle: TextStyles.h5
                                      .copyWith(color: ColorPalette.rankText),
                                  helperText: " ",
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: TextFormField(
                                controller: _accountNameController,
                                keyboardType: TextInputType.text,
                                style: TextStyles.h5,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: ColorPalette.bgTextFieldColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 10,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 5,
                                        color: ColorPalette.bgTextFieldColor),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  labelText: "Account Name",
                                  labelStyle: TextStyles.h5
                                      .copyWith(color: ColorPalette.rankText),
                                  helperText: " ",
                                ),
                              ),
                            ),
                          ] else ...[
                            Visibility(
                              visible: !_isOwner,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: TextFormField(
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  controller: _desiredPriceController,
                                  validator: _registerFormPresenter
                                      ?.validateDesiredPrice,
                                  keyboardType: TextInputType.number,
                                  style: TextStyles.h5,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ColorPalette.bgTextFieldColor,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 10,
                                            color:
                                                ColorPalette.bgTextFieldColor),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 5,
                                            color:
                                                ColorPalette.bgTextFieldColor),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    labelText: "Desired Room Price (VND)",
                                    labelStyle: TextStyles.h5
                                        .copyWith(color: ColorPalette.rankText),
                                    helperText: " ",
                                  ),
                                  obscureText: false,
                                ),
                              ),
                            ),
                            const Gap(5),
                            Visibility(
                              visible: !_isOwner,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: TextFormField(
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  controller: _desiredLocationController,
                                  validator: _registerFormPresenter!
                                      .validateDesiredLocation,
                                  keyboardType: TextInputType.streetAddress,
                                  style: TextStyles.h5,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ColorPalette.bgTextFieldColor,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 10,
                                            color:
                                                ColorPalette.bgTextFieldColor),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 5,
                                            color:
                                                ColorPalette.bgTextFieldColor),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    labelText: "Desired Location",
                                    labelStyle: TextStyles.h5
                                        .copyWith(color: ColorPalette.rankText),
                                    helperText: " ",
                                  ),
                                  obscureText: false,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Gap(30),

                    //TODO: Extract this button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 38),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool? locationResult =
                                await _registerFormPresenter?.isValidLocation(
                                    _desiredLocationController.text);
                            if (locationResult == true || _isOwner) {
                              _registerFormPresenter?.doneButtonPressed(
                                  widget.email,
                                  _accountPasswordTextController.text,
                                  _fullnameTextController.text,
                                  _phoneNumTextController.text,
                                  _gender,
                                  birthday,
                                  _isOwner,
                                  _imageFile,
                                  _isOwner
                                      ? 'None'
                                      : _desiredPriceController.text,
                                  _selectedBank ?? '',
                                  _accountNumberController.text,
                                  _accountNameController.text);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: ColorPalette.greenText,
                                  content: Text(
                                    'Invalid location! Try again',
                                    style: TextStyle(
                                        color: ColorPalette.errorColor),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primaryColor,
                          foregroundColor: ColorPalette.blackText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 80),
                          child: Text(
                            'Done',
                            style: TextStyles.h4.copyWith(
                                fontFamily: GoogleFonts.ntr().fontFamily),
                          ),
                        ),
                      ),
                    ),
                    const Gap(30),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  void onRegisterFailed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Cannot Sign up! Please try again later!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
  }

  @override
  void onRegisterSucceeded() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Sign up succeeded! You can now log in!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
    GoRouter.of(context).go('/log_in');
  }

  @override
  void onChangeProfilePicture(String pickedImage) {
    setState(() {
      _imageFile = pickedImage;
    });
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

  @override
  void onFetchBankList(List bankList) {
    setState(() {
      _bankList = [
        {
          'id': 0,
          'bin': '',
          'shortName': 'I don\'t want to provide banking \ninformation',
          'logo': '',
        },
        ...bankList.map((bank) {
          return {
            'id': bank['id'],
            'bin': bank['bin'],
            'shortName': bank['shortName'],
            'logo': bank['logo'],
          };
        }),
      ];
    });
  }
}
