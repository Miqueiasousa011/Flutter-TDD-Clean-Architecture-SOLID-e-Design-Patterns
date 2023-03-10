import 'package:get/get.dart';

mixin NavigateManager on GetxController {
  final _navigateTo = Rx<String?>(null);
  Stream<String?> get navigateToStream => _navigateTo.stream;
  set navigateTo(String? value) => _navigateTo.value = value;
}
