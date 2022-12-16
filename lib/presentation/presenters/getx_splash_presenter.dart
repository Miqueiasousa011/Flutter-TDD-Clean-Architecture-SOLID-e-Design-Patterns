import '../../domain/usecases/usecases.dart';
import '../../ui/pages/splash/splash.dart';
import '../mixins/mixins.dart';
import 'package:get/get.dart';

class GetxSplashPresenter extends GetxController
    with NavigateManager
    implements SplashPresenter {
  GetxSplashPresenter({required LoadCurrentAccountUsecase loadCurrentAccount})
      : _loadCurrentAccount = loadCurrentAccount;

  final LoadCurrentAccountUsecase _loadCurrentAccount;

  @override
  Future<void> checkAccount() async {
    try {
      final account = await _loadCurrentAccount.load();
      navigateTo = account == null ? '/login' : '/surveys';
      navigateTo = '/login';
    } catch (e) {
      navigateTo = '/login';
    }
  }
}
