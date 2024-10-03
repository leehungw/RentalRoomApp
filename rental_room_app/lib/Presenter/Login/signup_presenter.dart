import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Contract/Login/signup_contract.dart';
import 'package:string_validator/string_validator.dart';

class SignupPresenter {
  final SignupViewContract? _view;
  SignupPresenter(this._view);

  String? validateEmail(String? email) {
    email = email?.trim();
    if (email == null || email.isEmpty) {
      return "Please enter your email!";
    } else if (!isEmail(email)) {
      return "Email is not in the correct format!";
    }
    return null;
  }

  Future<bool?> _checkIfEmailInUse(String emailAddress) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: '123456',
      );
      await credential.user?.delete();
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return true;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> signup(String email) async {
    email = email.trim();
    _view?.onWaitingProgressBar();
    bool? result = await _checkIfEmailInUse(email);
    _view?.onPopContext();

    if (result == true) {
      _view?.onEmailAlreadyInUse();
    } else if (result == false) {
      _view?.onSignUpSucceeded();
    } else if (result == null) {
      _view?.onSignUpFailed();
    }
  }
}
