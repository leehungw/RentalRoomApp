import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_room_app/Contract/register_form_contract.dart';

class RegisterFormPresenter {
  final RegisterFormContract? _view;
  RegisterFormPresenter(this._view);

  String? password;
  Location? desiredLocation;

  //*
  //Validators
  //*
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
    // RegExp regex = RegExp(r'[^a-zA-Z\s]');

    if (name == null || name.isEmpty) {
      return "Please enter your full name!";
      // } else if (regex.hasMatch(name)) {
      //   return "Name must not contain numbers or symbols!";
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

  String? validateAccountPassword(String? password) {
    password = password?.trim();
    this.password = password;
    if (password == null || password.isEmpty) {
      return "Please enter your password!";
    } else if (password.length < 6) {
      return "Password must have at least 6 characters!";
    }
    return null;
  }

  String? validateConfirmPassword(String? password) {
    password = password?.trim();
    if (password == null || password.isEmpty) {
      return "Please confirm your password!";
    } else if (this.password != password) {
      return "Passwords do not match!";
    }
    return null;
  }

  String? validateDesiredPrice(String? value) {
    value = value?.trim();
    RegExp reg = RegExp(r'^\d+$');
    if (value == null || value.isEmpty) {
      return "Please enter your desired price!";
    } else if (!reg.hasMatch(value) || value[0] == '0') {
      return "Invalid Price value!";
    }
    return null;
  }

  Future<bool> isValidLocation(String value) async {
    List<Location> locations = [];
    try {
      locations = await locationFromAddress(value);
    } catch (e) {
      return false;
    }
    if (locations.isEmpty) {
      return false;
    }
    desiredLocation = locations.first;
    return true;
  }

  String? validateDesiredLocation(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return "Please enter your desired location!";
    } else {
      return null;
    }
  }

  //*
  //Screen Logics
  //*

  Future<UserCredential?> _registerWithEmailAndPassword(
      String email,
      String password,
      String displayName,
      String phone,
      String gender,
      DateTime birthday,
      bool isOwner,
      String? avatar,
      String desiredPrice) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (avatar != null && avatar.isNotEmpty) {
        // Upload File to Firebase Storage
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('avatars')
            .child('${userCredential.user!.uid}.jpg');
        Uint8List imageData = await File(avatar).readAsBytes();
        await ref.putData(
            imageData, SettableMetadata(contentType: 'image/jpeg'));

        String url = await ref.getDownloadURL();
        await userCredential.user!.updatePhotoURL(url);
      } else {
        await userCredential.user!.updatePhotoURL(
            'https://firebasestorage.googleapis.com/v0/b/rental-room-c34cb.appspot.com/o/avatar.jpg?alt=media&token=e9a9f6f6-9200-405a-98b4-5ae1130cd4bf');
      }

      await userCredential.user!.updateDisplayName(displayName);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'userID': userCredential.user!.uid,
        'email': email,
        'name': displayName,
        'phone': phone,
        'birthDay': birthday,
        'gender': gender,
        'isOwner': isOwner,
        'desiredPrice': desiredPrice,
        'desiredLocation_Long':
            isOwner ? 'None' : desiredLocation?.longitude.toString(),
        'desiredLocation_Lat':
            isOwner ? 'None' : desiredLocation?.latitude.toString(),
        'latestTappedRoomId': 'None',
      });
      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user: $e');
      }
      return null;
    }
  }

  void selectImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _view?.onChangeProfilePicture(pickedImage.path);
    }
  }

  Future<void> doneButtonPressed(
      String? email,
      String password,
      String displayName,
      String phone,
      String gender,
      DateTime birthday,
      bool isOwner,
      String? avatar,
      String desiredPrice) async {
    email = email?.trim();
    password = password.trim();
    displayName = displayName.trim();
    _view?.onWaitingProgressBar();

    UserCredential? result = await _registerWithEmailAndPassword(
        email!,
        password,
        displayName,
        phone,
        gender,
        birthday,
        isOwner,
        avatar,
        desiredPrice);
    _view?.onPopContext();
    if (result == null) {
      _view?.onRegisterFailed();
    } else {
      _view?.onRegisterSucceeded();
    }
  }
}
