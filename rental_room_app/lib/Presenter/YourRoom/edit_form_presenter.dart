import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Contract/YourRoom/edit_form_contract.dart';
import 'package:string_validator/string_validator.dart';

class EditFormPresenter {
  final EditFormContract? _view;
  EditFormPresenter(this._view);

  String? password;

  //*
  //Validators
  //*

  String? validateIdentification(String? id) {
    if (id == null || id.isEmpty) {
      return "Please enter your identification!";
    }
    if (id.length != 12) {
      return "Invalid identification!";
    }
    return null;
  }

  String? validateStartDate(DateTime? startDate) {
    DateTime today = DateTime.now();
    DateTime startDateOnly =
        DateTime(startDate!.year, startDate.month, startDate.day);
    DateTime todayOnly = DateTime(today.year, today.month, today.day);
    if (startDateOnly.isBefore(todayOnly)) {
    return "Invalid start date!";
  }
    return null;
  }

  String? validateFacebook(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return null;
    } else if (!isURL(value)) {
      return "Invalid Facebook link!";
    }
    return null;
  }

  String? validateRoomId(String? p1) {
    return null;
  }

  String? validateDeposit(String? deposit) {
    if (deposit == null || deposit.isEmpty) {
      return "Please enter deposit!";
    }
    if (deposit.contains(',')) {
      return "Please use '.' instead of ','!";
    }
    double depositValue;
    try {
      depositValue = double.parse(deposit);
    } catch (e) {
      return "Invalid deposit!";
    }
    if (depositValue <= 0) {
      return "Deposit must be greater than 0!";
    }
    return null;
  }

  Future<void> updateForm(
      String roomId,
      String identext,
      String numbertext,
      DateTime? startDate,
      String durationtext,
      String deposittext,
      String FBtext) async {
    _view?.onWaitingProgressBar();
    //Send data to server
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final String rentalID = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the room document
      DocumentReference roomRef = firestore.collection('Rooms').doc(roomId);

      // Add tenant information in the room document
      await roomRef.collection('tenant').doc(rentalID).update({
        'identity': identext,
        'numberPeople': int.parse(numbertext),
        'startDate': startDate,
        'duration': int.parse(durationtext),
        'deposit': int.parse(deposittext),
        'facebook': FBtext,
        'rentalID': rentalID,
      });

      _view?.onPopContext();
      _view?.onUpdateSucceed();
    } catch (e) {
      _view?.onUpdateFailed();
    }
  }
}
