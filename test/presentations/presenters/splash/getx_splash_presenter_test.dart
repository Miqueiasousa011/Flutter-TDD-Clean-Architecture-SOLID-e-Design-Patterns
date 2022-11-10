import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/ui/pages/splash/splash.dart';

import 'getx_splash_presenter_test.mocks.dart';

class GetxSplashPresenter implements SplashPresenter {
  GetxSplashPresenter({required LoadCurrentAccountUsecase loadCurrentAccount})
      : _loadCurrentAccount = loadCurrentAccount;

  final LoadCurrentAccountUsecase _loadCurrentAccount;

  final _navigateTo = Rx<String?>(null);

  @override
  Future<void> checkAccount() async {
    await _loadCurrentAccount.load();
  }

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;
}

@GenerateMocks([LoadCurrentAccountUsecase])
void main() {
  late GetxSplashPresenter sut;
  late MockLoadCurrentAccountUsecase loadCurrentAccount;

  setUp(() {
    loadCurrentAccount = MockLoadCurrentAccountUsecase();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  test('Should call loadCurrent account', () async {
    when(loadCurrentAccount.load())
        .thenAnswer((_) async => const AccountEntity(token: 'any'));

    await sut.checkAccount();

    verify(loadCurrentAccount.load());
  });

  test('Should call loadCurrent account', () async {
    when(loadCurrentAccount.load())
        .thenAnswer((_) async => const AccountEntity(token: 'any'));

    await sut.checkAccount();

    verify(loadCurrentAccount.load());
  });
}
