import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'local_save_current_account_test.mocks.dart';

class LocalSaveCorrentAccount implements SaveCurrentAccountUsecase {
  final SaveSegureCacheStorage _saveSecureCacheStorage;

  LocalSaveCorrentAccount({
    required SaveSegureCacheStorage saveSecureCacheStorage,
  }) : _saveSecureCacheStorage = saveSecureCacheStorage;

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await _saveSecureCacheStorage.save(key: 'token', value: account.token);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSegureCacheStorage {
  Future<void> save({required String key, required String value});
}

@GenerateMocks([SaveSegureCacheStorage])
void main() {
  late LocalSaveCorrentAccount sut;
  late AccountEntity accountEntity;
  late String token;
  late MockSaveSegureCacheStorage saveSecureCacheStorage;

  setUp(() {
    token = faker.guid.guid();
    accountEntity = AccountEntity(token: token);
    saveSecureCacheStorage = MockSaveSegureCacheStorage();
    sut = LocalSaveCorrentAccount(
      saveSecureCacheStorage: saveSecureCacheStorage,
    );
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(accountEntity);

    verify(saveSecureCacheStorage.save(key: 'token', value: token));
  });

  test('Should throw  UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    when(saveSecureCacheStorage.save(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());

    final future = sut.save(accountEntity);

    expect(future, throwsA(DomainError.unexpected));
  });
}
