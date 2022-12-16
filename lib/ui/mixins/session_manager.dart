import 'package:get/get.dart';

mixin SessionManager {
  void handleSessionExpired(Stream<bool?> stream) {
    stream.listen((sessionExpired) {
      if (sessionExpired == true) {
        Get.offAllNamed('/login');
      }
    });
  }
}
