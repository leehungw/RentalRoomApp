import 'package:flutter/material.dart';
import 'package:rental_room_app/Presenter/Login/login_presenter.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final LoginPresenter? presenter;

  const ForgotPasswordDialog({Key? key, required this.presenter})
      : super(key: key);

  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Forgot Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyles.descriptionRoom.copyWith(
              color: ColorPalette.grayText,
              fontSize: 16,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            String email = _emailController.text.trim();
            if (email.isNotEmpty) {
              Navigator.of(context).pop();
              widget.presenter!.resetPassword(email);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter your email'),
                ),
              );
            }
          },
          child: Text(
            'Reset Password',
            style: TextStyles.descriptionRoom.copyWith(
              color: ColorPalette.primaryColor,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
