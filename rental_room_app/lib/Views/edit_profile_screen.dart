import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rental_room_app/Contract/edit_profile_contract.dart';
import 'package:rental_room_app/Contract/shared_preferences_presenter.dart';
import 'package:rental_room_app/Presenter/edit_profile_presenter.dart';
import 'package:rental_room_app/Presenter/shared_preferences_presenter.dart';
import 'package:rental_room_app/Views/home_screen.dart';
import 'package:rental_room_app/config/asset_helper.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/custom_text_field.dart';
import 'package:rental_room_app/widgets/model_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    implements EditProfileContract, SharedPreferencesContract {
  SharedPreferencesPresenter? _preferencesPresenter;
  EditProfilePresenter? _editProfilePresenter;
  final _formKey = GlobalKey<FormState>();

  final _fullnameTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  String _gender = "";
  DateTime birthday = DateTime.now();

  String _userName = "nguyen van a";
  String _email = "nguyenvana@gmail.com";
  String _userAvatarUrl = '';

  @override
  void initState() {
    super.initState();
    _editProfilePresenter = EditProfilePresenter(this);
    _preferencesPresenter = SharedPreferencesPresenter(this);
    _preferencesPresenter?.getUserInfoFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
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
              onTap: () => context.pop(),
              child: const Icon(
                FontAwesomeIcons.arrowLeft,
                color: ColorPalette.backgroundColor,
                shadows: [Shadow(color: Colors.black12, offset: Offset(3, 6))],
              ),
            ),
          ),
          title: Text('EDIT PROFILE',
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
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorPalette.backgroundColor,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: ColorPalette.backgroundColor,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(45),
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        height: 132,
                        width: 132,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: _userAvatarUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(_userAvatarUrl),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage(AssetHelper.avatar),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Text(
                      _userName,
                      style: TextStyles.title,
                    ),
                    Text(
                      _email,
                      style: TextStyles.descriptionRoom.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const Gap(30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Full Name",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          )
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: CustomFormField.textFormField(
                        stringValidator:
                            _editProfilePresenter!.validateFullName,
                        editingController: _fullnameTextController,
                        keyboardType: TextInputType.name,
                        textAlign: TextAlign.center,
                        style: TextStyles.h6.italic,
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Gender",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          )
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
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
                            },
                          ),
                          const Text(
                            "Female",
                            style: TextStyles.h5,
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Phone Number",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          )
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: CustomFormField.textFormField(
                        stringValidator:
                            _editProfilePresenter!.validatePhoneNum,
                        editingController: _phoneTextController,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.center,
                        style: TextStyles.h6.italic,
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Birthday",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          )
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: CustomFormField.dateFormField(
                        dateTimeValidator:
                            _editProfilePresenter!.validateBirthday,
                        style: TextStyles.h6.italic,
                        onChangedDateTime: (value) {
                          setState(() {
                            birthday = value!;
                          });
                        },
                      ),
                    ),
                    const Gap(20),
                    ModelButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _editProfilePresenter?.onUpdateProfile(
                              _fullnameTextController.text,
                              _gender,
                              _phoneTextController.text,
                              birthday,
                            );
                          }
                        },
                        name: "Save",
                        color: ColorPalette.primaryColor.withOpacity(0.75),
                        width: 150),
                    const Gap(10),
                    ModelButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        name: "Cancel",
                        color: ColorPalette.redColor.withOpacity(0.75),
                        width: 150),
                    const Gap(30),
                    RichText(
                      text: TextSpan(style: TextStyles.h6, children: <TextSpan>[
                        TextSpan(
                            text: "Do you want to change password? ",
                            style: TextStyles.h6.copyWith(
                                fontFamily: GoogleFonts.ntr().fontFamily)),
                        TextSpan(
                            text: "Change Password!",
                            style: TextStyles.h6.copyWith(
                                fontFamily: GoogleFonts.ntr().fontFamily,
                                color: ColorPalette.greenText),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                GoRouter.of(context).go(
                                    '/setting/edit_profile/change_password');
                              })
                      ]),
                    ),
                    const Gap(60),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void onUpdateProfileSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Profile"),
          content: const Text("Update profile successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
  }

  @override
  void onUpdateProfileFailed() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Profile"),
          content: const Text("Update profile failed!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void updateView(
      String? userName, bool? isOwner, String? userAvatarUrl, String? email) {
    setState(() {
      _userName = userName ?? _userName;
      _userAvatarUrl = userAvatarUrl ?? _userAvatarUrl;
      _email = email ?? _email;
    });
  }
}
