import 'package:permission_handler/permission_handler.dart';
import 'package:rental_room_app/Contract/Home/home_contract.dart';

class HomePresenter {
  final HomeContract? _view;
  HomePresenter(this._view);

  // List<Room> filterRoom(List<Room> list) {
  //   List<Room> newList = List.from(list);
  //   newList = list.where((element) => element.ownerId == userID).toList();
  //   if (priceDesc == true) {
  //     newList.sort((a, b) => b.price.roomPrice.compareTo(a.price.roomPrice));
  //   }
  //   if (priceDesc == false) {
  //     newList.sort((a, b) => a.price.roomPrice.compareTo(b.price.roomPrice));
  //   }
  //   if (areaDesc == true) {
  //     newList.sort((a, b) => b.area.compareTo(a.area));
  //   }
  //   if (areaDesc == false) {
  //     newList.sort((a, b) => a.area.compareTo(b.area));
  //   }

  //   switch (kindRoom) {
  //     case 'All':
  //       break;
  //     case 'Standard':
  //       newList = newList
  //           .where((element) =>
  //               element.kind == 'Standard Room' && element.isAvailable)
  //           .toList();
  //       break;
  //     case 'Loft':
  //       newList = newList
  //           .where(
  //               (element) => element.kind == 'Loft Room' && element.isAvailable)
  //           .toList();
  //       break;
  //     case 'House':
  //       newList = newList
  //           .where((element) => element.kind == 'House' && element.isAvailable)
  //           .toList();
  //       break;
  //     default:
  //       break;
  //   }
  //   if (valueSearch != null) {
  //     newList = newList
  //         .where((element) =>
  //             element.location
  //                 .toLowerCase()
  //                 .contains(valueSearch!.toLowerCase()) &&
  //             element.isAvailable)
  //         .toList();
  //   }
  //   return newList;
  // }

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (!status.isGranted) {
      PermissionStatus result = await Permission.location.request();
      if (result.isDenied) {
        print('Permission denied');
      }
    }
  }

  // Future<void> loadRentalRoom() async {
  //   CollectionReference rentalroomRef = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userID)
  //       .collection('rentalroom');

  //   try {
  //     // Truy vấn tất cả các documents bên trong rentalroom
  //     QuerySnapshot querySnapshot = await rentalroomRef.get();

  //     if (querySnapshot.docs.isEmpty) {
  //       print('No documents found.');
  //       return;
  //     }

  //     DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
  //     Map<String, dynamic> rentalRoomData =
  //         documentSnapshot.data() as Map<String, dynamic>;

  //     setState(() {
  //       rentalID = rentalRoomData['roomID'];
  //     });
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('yourRoomId', rentalID);
  //     if (rentalID.isNotEmpty) {
  //       yourRoom = await RoomRepositoryIml().getRoomById(rentalID);
  //     }
  //   } catch (e) {
  //     print('Error getting document: $e');
  //   }
  // }
}
