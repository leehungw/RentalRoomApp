import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:rental_room_app/Contract/Login/login_contract.dart';
import 'package:rental_room_app/Presenter/Login/login_presenter.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/forgot_password_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    implements LoginViewContract {
  LoginPresenter? _loginPresenter;
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool _passwordVisible = true;

  bool _isChecked = false;

  BuildContext? progressbarContext;

  @override
  void initState() {
    _loginPresenter = LoginPresenter(this);
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Gap(100),
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: Image.asset(
                          'assets/images/login_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Gap(40),
                      Text(
                        "LOGIN",
                        style: TextStyles.h1.copyWith(
                            fontFamily: GoogleFonts.ntr().fontFamily,
                            color: ColorPalette.darkBlueText),
                      ),
                      const Gap(30),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: emailController,
                              validator: _loginPresenter?.validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyles.h6,
                              decoration: InputDecoration(
                                hintText: "Email",
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
                          const Gap(10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: passwordController,
                              validator: _loginPresenter?.validatePassword,
                              style: TextStyles.h6,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyles.h5.copyWith(
                                    fontFamily: GoogleFonts.ntr().fontFamily,
                                    color: ColorPalette.detailBorder),
                                prefixIcon: const Icon(IconlyLight.lock),
                                prefixIconColor: ColorPalette.detailBorder,
                                helperText: "",
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                      () {
                                        _passwordVisible = !_passwordVisible;
                                      },
                                    );
                                  },
                                ),
                              ),
                              obscureText: _passwordVisible,
                              obscuringCharacter: '*',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Gap(35),
                          Checkbox(
                            value: _isChecked,
                            onChanged: (value) =>
                                setState(() => _isChecked = value!),
                            checkColor: ColorPalette.backgroundColor,
                            side: const BorderSide(
                                width: 2, color: ColorPalette.primaryColor),
                            activeColor: ColorPalette.primaryColor,
                          ),
                          Text(
                            'Remember me',
                            style: TextStyles.h6.copyWith(
                                fontStyle: FontStyle.italic,
                                color: ColorPalette.primaryColor),
                          ),
                        ],
                      ),
                      const Gap(30),

                      //TODO: extract this button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 38),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _loginPresenter?.login(emailController.text,
                                  passwordController.text);
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
                              'LOG IN',
                              style: TextStyles.h4.copyWith(
                                  fontFamily: GoogleFonts.ntr().fontFamily),
                            ),
                          ),
                        ),
                      ),
                      const Gap(30),
                      RichText(
                        text:
                            TextSpan(style: TextStyles.h6, children: <TextSpan>[
                          TextSpan(
                              text: "Don't have account?       ",
                              style: TextStyles.h5.copyWith(
                                  fontFamily: GoogleFonts.ntr().fontFamily)),
                          TextSpan(
                              text: "Register Now!",
                              style: TextStyles.h5.copyWith(
                                  fontFamily: GoogleFonts.ntr().fontFamily,
                                  color: ColorPalette.greenText),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  GoRouter.of(context).go('/log_in/sign_up');
                                })
                        ]),
                      ),
                      const Gap(20),
                      RichText(
                          text: TextSpan(
                              text: "Forgot password?",
                              style: TextStyles.h5.copyWith(
                                  fontFamily: GoogleFonts.ntr().fontFamily,
                                  color: ColorPalette.greenText),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ForgotPasswordDialog(
                                        presenter: _loginPresenter),
                                  );
                                })),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  void onLoginFailed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Wrong Email or Password. Please try again!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
  }

  @override
  void onLoginSucceeded() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Login Succeeded',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
    GoRouter.of(context).go('/home');
  }

  @override
  void onWaitingProgressBar() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          progressbarContext = context;
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  void onPopContext() {
    Navigator.of(progressbarContext??context).pop();
  }

  @override
  void onForgotPasswordSent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Reset password email sent. Please check your email!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
  }

  @override
  void onForgotPasswordError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          errorMessage,
          style: const TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
  }
}
