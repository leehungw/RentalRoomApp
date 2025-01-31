import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:rental_room_app/router.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    final isDisconnected = connectivityResults.every((result) => result == ConnectivityResult.none);

    if (isDisconnected) {
      router.go('/nointernet');
    } else {
      router.go('/');
    }
  }
}
