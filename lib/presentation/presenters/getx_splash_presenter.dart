import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/splash/splash.dart';

class GetxSplashPresenter implements SplashPresenter {
  GetxSplashPresenter({required LoadCurrentAccountUsecase loadCurrentAccount})
      : _loadCurrentAccount = loadCurrentAccount;

  final LoadCurrentAccountUsecase _loadCurrentAccount;

  final _navigateTo = Rx<String?>(null);

  @override
  Future<void> checkAccount() async {
    try {
      final account = await _loadCurrentAccount.load();
      _navigateTo.value = account == null ? '/login' : '/surveys';
    } catch (e) {
      _navigateTo.value = '/login';
    }
  }

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;
}
