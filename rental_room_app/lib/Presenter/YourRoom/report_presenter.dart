import 'package:rental_room_app/Contract/YourRoom/report_contract.dart';

class ReportPresenter {
  // ignore: unused_field
  final ReportContract? _view;
  ReportPresenter(this._view);

  void _fetchRoomData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Rooms')
        .where('ownerId', isEqualTo: oID)
        .get();

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

    setState(() {
      totalRooms = tempTotalRooms;
      occupiedRooms = tempOccupiedRooms;
      isLoading = false;
      totalRooms.forEach((key, value) {
        _totalRoom += value;
      });
    });
  }
}
