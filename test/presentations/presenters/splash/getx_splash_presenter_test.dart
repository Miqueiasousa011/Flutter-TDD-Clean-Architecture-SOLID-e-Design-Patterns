import 'package:faker/faker.dart';
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
    final account = await _loadCurrentAccount.load();
    _navigateTo.value = account == null ? '/login' : '/surveys';
  }

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;
}

@GenerateMocks([LoadCurrentAccountUsecase])
void main() {
  late GetxSplashPresenter sut;
  late MockLoadCurrentAccountUsecase loadCurrentAccount;
  late AccountEntity account;

  setUp(() {
    account = AccountEntity(token: faker.guid.guid());
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
    when(loadCurrentAccount.load()).thenAnswer((_) async => account);

    await sut.checkAccount();

    verify(loadCurrentAccount.load());
  });

  test('Should go to surveys page on success', () async {
    when(loadCurrentAccount.load()).thenAnswer((_) async => account);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkAccount();
  });

  test('Should go to login on null result', () async {
    when(loadCurrentAccount.load()).thenAnswer((_) async => null);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkAccount();
  });
}
