import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:rental_room_app/Contract/signup_contract.dart';
import 'package:rental_room_app/Presenter/signup_presenter.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    implements SignupViewContract {
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  SignupPresenter? _signupPresenter;

  @override
  void initState() {
    _signupPresenter = SignupPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            reverse: true,
            child: Center(
              child: Container(
                color: ColorPalette.backgroundColor,
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(150),
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Image.asset(
                        'assets/images/signup_logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Gap(40),
                    Text(
                      "Register",
                      style: TextStyles.h1.copyWith(
                          fontFamily: GoogleFonts.ntr().fontFamily,
                          color: ColorPalette.darkBlueText),
                    ),
                    const Gap(100),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: TextFormField(
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _signupPresenter?.validateEmail,
                          style: TextStyles.h6,
                          decoration: InputDecoration(
                            hintText: "Email Address",
                            hintStyle: TextStyles.h5.copyWith(
                                fontFamily: GoogleFonts.ntr().fontFamily,
                                color: ColorPalette.detailBorder),
                            prefixIcon: const Icon(IconlyLight.profile),
                            prefixIconColor: ColorPalette.detailBorder,
                            helperText: "",
                          ),
                          obscureText: false,
                        ),
                      ),
                    ),
                    const Gap(40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 38),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signupPresenter?.signup(_emailController.text);
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
                            'Register',
                            style: TextStyles.h4.copyWith(
                                fontFamily: GoogleFonts.ntr().fontFamily),
                          ),
                        ),
                      ),
                    ),
                    const Gap(50),
                    RichText(
                      text: TextSpan(style: TextStyles.h6, children: <TextSpan>[
                        TextSpan(
                            text: "Already have an account?  ",
                            style: TextStyles.h5.copyWith(
                                fontFamily: GoogleFonts.ntr().fontFamily)),
                        TextSpan(
                            text: "Log In",
                            style: TextStyles.h5.copyWith(
                                fontFamily: GoogleFonts.ntr().fontFamily,
                                color: ColorPalette.greenText),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pop();
                              })
                      ]),
                    ),
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
  void onSignUpFailed() {
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
  void onSignUpSucceeded() {
    String email = _emailController.value.text.trim();
    GoRouter.of(context).goNamed('pincode', pathParameters: {'email': email});
  }

  @override
  void onEmailAlreadyInUse() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Email Already In Use! Try a different email!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
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
}
