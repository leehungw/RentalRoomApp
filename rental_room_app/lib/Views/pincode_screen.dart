import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rental_room_app/Contract/pincode_contract.dart';
import 'package:rental_room_app/Presenter/pincode_presenter.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';

class PincodeScreen extends StatefulWidget {
  final String? email;
  const PincodeScreen({super.key, this.email});

  @override
  State<PincodeScreen> createState() => _PincodeScreenState();
}

class _PincodeScreenState extends State<PincodeScreen>
    implements PincodeViewContract {
  final _formKey = GlobalKey<FormState>();
  bool hasError = false;
  String currentText = "";
  String pinCode = '';
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController textEditingController = TextEditingController();

  PincodePresenter? _pincodePresenter;

  @override
  void initState() {
    _pincodePresenter = PincodePresenter(this, widget.email);
    _pincodePresenter?.initSendPincode();
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
                    const Gap(100),
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Image.asset(
                        'assets/images/pincode_logo.png',
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
                    const Gap(30),
                    Text(
                      "OTP has been sent to",
                      style: TextStyles.h5.copyWith(
                          fontFamily: GoogleFonts.ntr().fontFamily,
                          color: ColorPalette.blackText),
                    ),
                    const Gap(10),
                    Text(
                      widget.email.toString(),
                      style: TextStyles.h3.copyWith(
                          fontFamily: GoogleFonts.ntr().fontFamily,
                          color: ColorPalette.blackText),
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            "Your OTP Code:",
                            style: TextStyles.h4.copyWith(
                                fontFamily: GoogleFonts.ntr().fontFamily,
                                color: ColorPalette.greenText),
                          ),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v!.length < 6) {
                              return ""; // nothing to show
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(20),
                            fieldHeight: 50,
                            fieldWidth: 50,
                            activeColor: ColorPalette.primaryColor,
                            activeFillColor: ColorPalette.primaryColor,
                            selectedColor: ColorPalette.primaryColor,
                            selectedFillColor: ColorPalette.primaryColor,
                            inactiveColor:
                                ColorPalette.primaryColor.withOpacity(0.44),
                            inactiveFillColor:
                                ColorPalette.primaryColor.withOpacity(0.44),
                          ),
                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 300),
                          textStyle: const TextStyle(fontSize: 20, height: 1.6),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          onCompleted: (value) {
                            setState(() {
                              currentText = value;
                            });
                            _pincodePresenter?.pincodeVerify(value);
                          },
                          beforeTextPaste: (text) {
                            if (kDebugMode) {
                              print("Allowing to paste $text");
                            }
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        ),
                      ),
                    ),
                    const Gap(50),
                    ResendCountdown(onResendClick: () {
                      _pincodePresenter?.resendConfirmationCode();
                    })
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
  void onWrongPincodeError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Wrong PINCODE! Please try again!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
  }

  @override
  void onVerifySucceeded() {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     backgroundColor: ColorPalette.greenText,
    //     content: Text(
    //       'Verify Succeeded!',
    //       style: TextStyle(color: ColorPalette.errorColor),
    //     ),
    //   ),
    // );
    GoRouter.of(context)
        .goNamed('register_form', pathParameters: {'email': widget.email!});
  }

  @override
  void onResendPincode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Pincode resent! Check your email!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
  }
}

class ResendCountdown extends StatefulWidget {
  final VoidCallback onResendClick;

  const ResendCountdown({Key? key, required this.onResendClick})
      : super(key: key);

  @override
  State<ResendCountdown> createState() => _ResendCountdownState();
}

class _ResendCountdownState extends State<ResendCountdown> {
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyles.h6,
        children: <TextSpan>[
          TextSpan(
              text: "Didn't get the OTP code?       ",
              style: TextStyles.h5
                  .copyWith(fontFamily: GoogleFonts.ntr().fontFamily)),
          TextSpan(
            text: _secondsRemaining > 0
                ? "Resend ($_secondsRemaining)"
                : "Resend",
            style: TextStyles.h5.copyWith(
                fontFamily: GoogleFonts.ntr().fontFamily,
                color: ColorPalette.greenText),
            recognizer: _secondsRemaining > 0 ? null : TapGestureRecognizer()
              ?..onTap = () {
                widget.onResendClick();
                _startTimer();
              },
          ),
        ],
      ),
    );
  }
}
