import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Contract/YourRoom/report_contract.dart';
import 'package:rental_room_app/Models/Room/room_repo.dart';

class ReportPresenter {
  // ignore: unused_field
  final ReportContract? _view;
  ReportPresenter(this._view);

  final RoomRepository _roomRepository = RoomRepositoryIml();

  void fetchRoomData() async {
    Map<String, int> tempTotalRooms = {
      'Standard Room': 0,
      'Loft Room': 0,
      'House': 0
    };
    Map<String, int> tempOccupiedRooms = {
      'Standard Room': 0,
      'Loft Room': 0,
      'House': 0
    };

    QuerySnapshot snapshot = await _roomRepository.getOwnedRoomSnapshot();

    for (var doc in snapshot.docs) {
      String roomType = doc['kind'];
      bool isAvailable = doc['isAvailable'];

      if (tempTotalRooms.containsKey(roomType)) {
        tempTotalRooms[roomType] = tempTotalRooms[roomType]! + 1;
        if (!isAvailable) {
          tempOccupiedRooms[roomType] = tempOccupiedRooms[roomType]! + 1;
        }
      } else {
        print('Room type $roomType is not recognized.');
      }
    }
  }
}
