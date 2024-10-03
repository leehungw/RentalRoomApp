import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Contract/Login/login_contract.dart';
import 'package:rental_room_app/Models/User/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';

class LoginPresenter {
  final LoginViewContract? _view;
  LoginPresenter(this._view);
  final UserRepository _userRepository = UserRepositoryIml();

  Future<void> login(String email, String password) async {
    _view?.onWaitingProgressBar();
    try {
      UserCredential userCredential =
          await _userRepository.signInWithEmailAndPassword(email, password);

      Map<String, dynamic> userData =
          await _userRepository.getUserData(userCredential.user!.uid);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userID', userCredential.user!.uid);
      prefs.setString('email', userData['email'] as String);
      prefs.setString('name', userData['name'] as String);
      prefs.setString('phone', userData['phone'] as String);
      prefs.setString(
          'birthDay', (userData['birthDay'] as Timestamp).toDate().toString());
      prefs.setString('gender', userData['gender'] as String);
      prefs.setBool('isOwner', userData['isOwner'] as bool);

      String? avatar = userCredential.user!.photoURL;
      prefs.setString('avatar', avatar ?? '');
    } catch (e) {
      _view?.onPopContext();
      _view?.onLoginFailed();
      return;
    }
    _view?.onPopContext();
    _view?.onLoginSucceeded();
  }

  String? validateEmail(String? email) {
    email = email?.trim();
    if (email == null || email.isEmpty) {
      return "Please enter your email!";
    } else if (!isEmail(email)) {
      return "Email is not in the correct format!";
    }
    return null;
  }

  String? validatePassword(String? password) {
    password = password?.trim();
    if (password == null || password.isEmpty) {
      return "Please enter your password!";
    }
    return null;
  }

  Future<void> resetPassword(String email) async {
    _view?.onWaitingProgressBar();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _view?.onForgotPasswordSent();
      _view?.onPopContext();
    } catch (e) {
      _view?.onForgotPasswordError(e.toString());
      _view?.onPopContext();
    }
  }
}
