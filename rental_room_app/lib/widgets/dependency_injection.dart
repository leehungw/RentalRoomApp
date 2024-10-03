import 'package:get/get.dart';
import 'package:rental_room_app/Contract/Setting/network_contract.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
