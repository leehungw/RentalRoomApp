import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Contract/YourRoom/detail_room_contract.dart';
import 'package:rental_room_app/Models/Comment/comment_model.dart';
import 'package:rental_room_app/Models/Comment/comment_repo.dart';
import 'package:rental_room_app/Models/User/user_repo.dart';

class DetailRoomPresenter {
  // ignore: unused_field
  final DetailRoomContract? _view;
  DetailRoomPresenter(this._view);

  final CommentRepository _commentRepository = CommentRepositoryIml();
  final UserRepository _userRepository = UserRepositoryIml();

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

  Future<void> _updateLatestTappedRoom() async {
    UserRepository userRepository = UserRepositoryIml();
    Users currentU = await userRepository
        .getUserById(FirebaseAuth.instance.currentUser!.uid);
    if (!currentU.isOwner) {
      _detailRoomPresenter?.logTappedRoomEvent(widget.room.roomId);
      // _detailRoomPresenter?.updateLatestTappedRoom(widget.room.roomId);
    }
  }

  Future<void> _beginProgram() async {
    if (!widget.room.isAvailable) {
      await _loadRentalID();
      await _loadReceiptStatus();
      _rentalRepository
          .getRentalData(rentalID, widget.room.roomId)
          .then((value) {
        setState(() {
          rental = value;
        });
      });

      _loadTenant();
    } else {
      rental = null;
    }
  }

  Future<void> _loadReceiptStatus() async {
    try {
      DateTime now = DateTime.now();

      CollectionReference receiptCollection =
          FirebaseFirestore.instance.collection('Receipts');

      // Query to filter and sort documents by 'createdDay' in descending order
      Query query = receiptCollection
          .where('roomID', isEqualTo: widget.room.roomId)
          .where('tenantID', isEqualTo: rentalID)
          .orderBy('createdDay', descending: true);

      QuerySnapshot querySnapshot;
      try {
        querySnapshot = await query.limit(1).get(); // Get the first document
      } catch (e) {
        print('Error fetching query snapshot: $e');
        setState(() {
          status = 'Error fetching data';
        });
        return;
      }

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          status = 'No receipt';
        });
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

      // Check if the duration exceeds the limit (number of days in the month)
      if (durationToClosestDay.inDays > daysInMonth) {
        setState(() {
          status = 'No receipt';
        });
      } else {
        // Check the status of the closest document
        bool sta = closestDoc['status'];
        setState(() {
          status = sta ? 'PAID' : 'UNPAID';
        });
      }
    } catch (e, stackTrace) {
      // Handle errors if needed
      print('Error loading receipt status: $e');
      print('StackTrace: $stackTrace');
      setState(() {
        status = 'Error loading receipt status';
      });
    }
  }

  Future<void> _loadRentalID() async {
    CollectionReference collection = FirebaseFirestore.instance
        .collection('Rooms')
        .doc(widget.room.roomId)
        .collection('tenant');
    QuerySnapshot querySnapshot = await collection.limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        rentalID = querySnapshot.docs[0].id;
        print('RentalID: $rentalID \n');
      });
    } else {
      print('Không tìm thấy rentalID');
      setState(() {
        rentalID = '';
      });
    }
  }

  Future<void> _loadTenant() async {
    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(rentalID)
        .collection('rentalroom')
        .doc(widget.room.roomId)
        .get();
    if (doc.exists) {
      DocumentSnapshot docUser =
          await _firestore.collection('users').doc(rentalID).get();
      if (docUser.exists) {
        setState(() {
          user = Users.fromFirestore(docUser);
        });
      }
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

  // Phương thức để load thông tin từ SharedPreferences
  Future<void> _loadInfor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isOwner = prefs.getBool('isOwner') ?? false;
    });
  }

  Future<void> checkOutRoom() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      QuerySnapshot rentalroomSnapshot = await _firestore
          .collection('users')
          .doc(rentalID)
          .collection('rentalroom')
          .get();
      for (var doc in rentalroomSnapshot.docs) {
        await doc.reference.delete();
      }

      // Xóa collection con 'tenant' trong 'room'
      QuerySnapshot tenantSnapshot = await _firestore
          .collection('Rooms')
          .doc(widget.room.roomId)
          .collection('tenant')
          .get();
      for (var doc in tenantSnapshot.docs) {
        await doc.reference.delete();
      }

      // Đổi thuộc tính isAvailable từ false sang true
      await _firestore
          .collection('Rooms')
          .doc(widget.room.roomId)
          .update({'isAvailable': true});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('yourRoomId');
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      print("Lỗi khi check out phòng: $e");
    }
  }

  Future<void> deleteRoom() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      await FirebaseFirestore.instance
          .collection('Rooms')
          .doc(widget.room.roomId)
          .delete();
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: ColorPalette.greenText,
          content: Text(
            'Xoá phòng trọ thành công!',
            style: TextStyle(color: ColorPalette.errorColor),
          ),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: ColorPalette.greenText,
          content: Text(
            'Xoá phòng trọ thất bại!',
            style: TextStyle(color: ColorPalette.errorColor),
          ),
        ),
      );
    }
  }
}
