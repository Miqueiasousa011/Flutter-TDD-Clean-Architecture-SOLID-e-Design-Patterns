import 'package:get/get.dart';

//Mixin utilizado para aplicar o principio DRY
mixin LoadingManager {
  final _isLoading = RxBool(false);
  Stream<bool> get isLoadingController => _isLoading.stream.distinct();
  set isLoading(bool value) => _isLoading.value = value;
}
