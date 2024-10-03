import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rental_room_app/Contract/Login/change_password_contract.dart';
import 'package:rental_room_app/Presenter/Login/change_password_presenter.dart';
import 'package:rental_room_app/config/asset_helper.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/model_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO: mvp refactor

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    implements ChangePasswordContract {
  ChangePasswordPresenter? _changePasswordPresenter;
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _oldPasswordVisible = true;
  bool _newPasswordVisible = true;
  bool _confirmPasswordVisible = true;

  late String userName;
  late String userAvatarUrl;
  late String email;

  String? oldPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;
  String? _errorMessage;
  String? currentPassword;

  @override
  void initState() {
    _changePasswordPresenter = ChangePasswordPresenter(this);
    getUserInfoFromSharedPreferences();
    super.initState();
  }

  Future<void> getUserInfoFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Nguyen Van A';
      userAvatarUrl = prefs.getString('avatar') ?? '';
      email = prefs.getString('email') ?? 'nguyenvana@gmail.com';
      currentPassword = prefs.getString('password');
    });
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        oldPasswordError = null;
        newPasswordError = null;
        confirmPasswordError = null;
      });
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      String oldPassword = _oldPasswordController.text.trim();
      String newPassword = _newPasswordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      User? user = FirebaseAuth.instance.currentUser;

      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);

      try {
        await user!.reauthenticateWithCredential(credential);
      } catch (error) {
        // Nếu xảy ra lỗi, hiển thị dialog thông báo lỗi
        setState(() {
          oldPasswordError = "Old password is incorrect.";
        });
        Navigator.of(context, rootNavigator: true).pop();
        return;
      }

      if (_newPasswordController.text.length < 6) {
        setState(() {
          newPasswordError = "New password must be at least 6 characters long.";
        });
        Navigator.of(context, rootNavigator: true).pop();
        return;
      } else {
        setState(() {
          newPasswordError = null;
        });
      }

      if (_newPasswordController.text != _confirmPasswordController.text) {
        setState(() {
          confirmPasswordError = "Confirm password does not match.";
        });
        Navigator.of(context, rootNavigator: true).pop();
        return;
      } else {
        setState(() {
          confirmPasswordError = null;
        });
      }

      try {
        await user.updatePassword(newPassword);
        Navigator.of(context, rootNavigator: true).pop();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text("Change Password"),
                content: const Text("Change password successfully!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      _oldPasswordController.clear();
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  )
                ],
              );
            });
      } catch (error) {
        setState(() {
          _errorMessage = error.toString();
        });
        Navigator.of(context, rootNavigator: true).pop();
        return;
      }
    }
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
          title: Text('CHANGE PASSWORD',
              style: TextStyles.slo.bold.copyWith(
                fontSize: 25,
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
                          image: userAvatarUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(userAvatarUrl),
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
                      userName,
                      style: TextStyles.h4.semibold.copyWith(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: ColorPalette.primaryColor),
                    ),
                    const Gap(5),
                    Text(email,
                        style: TextStyles.labelStaffDetail.regular.copyWith(
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            color: ColorPalette.detailBorder.withOpacity(0.7))),
                    const Gap(50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Old Password",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          )
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        controller: _oldPasswordController,
                        validator: _changePasswordPresenter?.validatePassword,
                        style: TextStyles.h6,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: ColorPalette.detailBorder),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: ColorPalette.primaryColor),
                              borderRadius: BorderRadius.circular(20)),
                          helperText: " ",
                          errorText: oldPasswordError,
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: ColorPalette.redColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: ColorPalette.redColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_oldPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  _oldPasswordVisible = !_oldPasswordVisible;
                                },
                              );
                            },
                          ),
                        ),
                        obscureText: _oldPasswordVisible,
                        obscuringCharacter: '*',
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "New Password",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          )
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        controller: _newPasswordController,
                        validator: _changePasswordPresenter?.validatePassword,
                        style: TextStyles.h6,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: ColorPalette.detailBorder),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: ColorPalette.primaryColor),
                              borderRadius: BorderRadius.circular(20)),
                          helperText: " ",
                          errorText: newPasswordError,
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: ColorPalette.redColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: ColorPalette.redColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_newPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  _newPasswordVisible = !_newPasswordVisible;
                                },
                              );
                            },
                          ),
                        ),
                        obscureText: _newPasswordVisible,
                        obscuringCharacter: '*',
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Confirm Password",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          )
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        controller: _confirmPasswordController,
                        validator: _changePasswordPresenter?.validatePassword,
                        style: TextStyles.h6,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: ColorPalette.detailBorder),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: ColorPalette.primaryColor),
                              borderRadius: BorderRadius.circular(20)),
                          helperText: " ",
                          errorText: confirmPasswordError,
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: ColorPalette.redColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: ColorPalette.redColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  _confirmPasswordVisible =
                                      !_confirmPasswordVisible;
                                },
                              );
                            },
                          ),
                        ),
                        obscureText: _confirmPasswordVisible,
                        obscuringCharacter: '*',
                      ),
                    ),
                    const Gap(20),
                    ModelButton(
                        onTap: () {
                          _changePassword();
                        },
                        name: "Change",
                        color: ColorPalette.primaryColor.withOpacity(0.75),
                        width: 150),
                    const Gap(10),
                    ModelButton(
                        onTap: () {
                          context.pop();
                        },
                        name: "Cancel",
                        color: ColorPalette.redColor.withOpacity(0.75),
                        width: 150),
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
}
