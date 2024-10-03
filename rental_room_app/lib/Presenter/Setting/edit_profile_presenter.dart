import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Contract/Setting/edit_profile_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePresenter {
  // ignore: unused_field
  final EditProfileContract? _view;
  EditProfilePresenter(this._view);

  String? validatePhoneNum(String? phoneNum) {
    phoneNum = phoneNum?.trim();
    if (phoneNum == null || phoneNum.isEmpty) {
      return "Please enter your phone number!";
    } else if (phoneNum.length > 11 || phoneNum.length < 8) {
      return "Phone number must have 8 to 11 digits!";
    }
    return null;
  }

  String? validateFullName(String? name) {
    name = name?.trim();
    List<String>? nameParts = name?.split(" ");

    if (name == null || name.isEmpty) {
      return "Please enter your full name!";
    } else if (name.length < 2) {
      return "Full name must contain at least 2 characters!";
    } else if (nameParts!.length < 2) {
      return "Full name should contain at least 2 parts (first name and last name)!";
    }
    return null;
  }

  String? validateGender(String? gender) {
    if (gender == null || gender.isEmpty) {
      return "Please choose your gender!";
    }
    return null;
  }

  String? validateBirthday(DateTime? birthday) {
    if (birthday == null) {
      return "Please enter your birthday!";
    } else if (birthday.isAfter(DateTime.now())) {
      return "Invalid birthday!";
    }
    return null;
  }

  Future<void> onUpdateProfile(String fullName, String gender,
      String phoneNumber, DateTime birthday) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({
          "name": fullName,
          "gender": gender,
          "phone": phoneNumber,
          "birthDay": birthday,
        });
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("name", fullName);

      _view?.onUpdateProfileSuccess();
    } catch (e) {
      print(e);
      _view?.onUpdateProfileFailed();
    }
  }
}
