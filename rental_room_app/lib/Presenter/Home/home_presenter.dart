import 'package:permission_handler/permission_handler.dart';
import 'package:rental_room_app/Contract/Home/home_contract.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Models/Room/room_repo.dart';

class HomePresenter {
  final HomeContract? _view;
  HomePresenter(this._view);

  final _roomRepository = RoomRepositoryIml();

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

  Future<void> loadRentalRoom(String rentalId) async {
    Room rentedRoom = await _roomRepository.getRoomById(rentalId);
    _view?.onUpdateYourRoom(rentedRoom);
  }
}

class RoomFilter {
  String? keyword;
  Kind? kind;
  double? minArea;
  double? maxArea;
  double? minPrice;
  double? maxPrice;

  RoomFilter({
    this.keyword,
    this.kind,
    this.minArea,
    this.maxArea,
    this.minPrice,
    this.maxPrice,
  });
}

