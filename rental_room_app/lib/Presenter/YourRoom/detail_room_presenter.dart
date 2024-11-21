import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Contract/YourRoom/detail_room_contract.dart';
import 'package:rental_room_app/Models/Comment/comment_model.dart';
import 'package:rental_room_app/Models/Comment/comment_repo.dart';
import 'package:rental_room_app/Models/Receipt/receipt_repo.dart';
import 'package:rental_room_app/Models/Rental/rental_repo.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Models/Room/room_repo.dart';
import 'package:rental_room_app/Models/User/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailRoomPresenter {
  // ignore: unused_field
  final DetailRoomContract? _view;
  DetailRoomPresenter(this._view);

  final CommentRepository _commentRepository = CommentRepositoryIml();
  final UserRepository _userRepository = UserRepositoryIml();
  final RentalRepository _rentalRepository = RentalRepositoryIml();
  final ReceiptRepository _receiptRepository = ReceiptRepositoryIml();
  final RoomRepository _roomRepository = RoomRepositoryIml();

  String? validateComment(String? content) {
    content = content?.trim();
    if (content != null) {
      if (content.isNotEmpty) {
        return null;
      }
      return "Please write something!";
    }
    return "Please write somthing!";
  }

  void postCommentButtonPressed(String roomId, String content, double rating) {
    content = content.trim();
    Comment comment = Comment(
        content: content,
        rating: rating,
        roomId: roomId,
        userId: FirebaseAuth.instance.currentUser!.uid,
        time: DateTime.now());
    _commentRepository.uploadComment(comment);
    FirebaseAnalytics.instance.logEvent(
        name: "user_rated_room",
        parameters: {"roomId": roomId, "rating": rating});
    if (rating >= 4) {
      _userRepository.updateLatestTappedRoom(roomId);
    }
    _view?.onCommentPosted();
  }

  void logTappedRoomEvent(String roomId) {
    FirebaseAnalytics.instance
        .logEvent(name: "user_tapped_room", parameters: {"roomId": roomId});
  }

  void updateLatestTappedRoom(String roomId) {
    _userRepository.updateLatestTappedRoom(roomId);
  }

  Future<void> beginProgram(Room room) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (!room.isAvailable) {
      await loadReceiptStatus(room.roomId, userId);
      try {
        _rentalRepository.getRentalData(userId, room.roomId).then((value) {
          _view?.onGetRental(value);
        });
      } catch (e) {
        print("================== Error begin program");
      }

      _view?.onGetTenant(
          await _userRepository.getUserByRentalId(userId, room.roomId));
    } else {
      _view?.onGetRental(null);
    }
  }

  Future<void> loadReceiptStatus(String roomId, String rentalId) async {
    try {
      DateTime now = DateTime.now();

      QuerySnapshot querySnapshot;
      try {
        querySnapshot =
            await _receiptRepository.getReceiptByRoomId(roomId, rentalId);
      } catch (e) {
        _view?.onSetReceiptStatus("Error fetching data");
        return;
      }

      if (querySnapshot.docs.isEmpty) {
        _view?.onSetReceiptStatus("No receipt");
        return;
      }

      DocumentSnapshot closestDoc = querySnapshot.docs.first;

      // Check the distance from today to the closest document's day
      Timestamp closestDayTimestamp = closestDoc['createdDay'];
      DateTime closestDay = closestDayTimestamp.toDate();
      int daysInMonth = DateTime(closestDay.year, closestDay.month + 1, 0)
          .day; // Get number of days in the month of the closest day's month
      Duration durationToClosestDay =
          closestDay.difference(now).abs(); // Absolute difference from today

      if (durationToClosestDay.inDays > daysInMonth) {
        _view?.onSetReceiptStatus("No receipt");
      } else {
        bool sta = closestDoc['status'];
        _view?.onSetReceiptStatus(sta ? 'PAID' : 'UNPAID');
      }
    } catch (e, stackTrace) {
      print('Error loading receipt status: $e');
      print('StackTrace: $stackTrace');
      _view?.onSetReceiptStatus('Error loading receipt status');
    }
  }

  Future<bool> isHaveRoom() async {
    try {
      String? uID = FirebaseAuth.instance.currentUser?.uid;
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uID);
      CollectionReference roomCollectionRef =
          userDocRef.collection('rentalroom');
      QuerySnapshot roomSnapshot = await roomCollectionRef.limit(1).get();

      return roomSnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Lỗi khi kiểm tra thuê phòng: $e");
      return false;
    }
  }

  Future<void> checkOutRoom(String roomId, String rentalId) async {
    _view?.onLoading();
    try {
      _userRepository.deleteRental(rentalId);
      _roomRepository.deleteTenant(roomId);
      _roomRepository.updateRoomAvailability(roomId, true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('yourRoomId');
      _view?.onPop();
      _view?.onRoutingToHome();
    } catch (e) {
      _view?.onPop();
      print("Lỗi khi check out phòng: $e");
    }
  }

  Future<void> deleteRoom(String roomId) async {
    _view?.onLoading();
    try {
      _roomRepository.deleteRoom(roomId);
      _view?.onPop();
      _view?.onDeleteRoomSuccess();
      _view?.onRoutingToHome();
    } catch (e) {
      _view?.onPop();
      _view?.onDeleteRoomFailed();
    }
  }
}
