import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'local_save_current_account_test.mocks.dart';

class LocalSaveCorrentAccount implements SaveCurrentAccountUsecase {
  final SaveSegureCacheStorage _saveSecureCacheStorage;

  LocalSaveCorrentAccount(
      {required SaveSegureCacheStorage saveSecureCacheStorage})
      : _saveSecureCacheStorage = saveSecureCacheStorage;

  @override
  Future<void> save(AccountEntity account) async {
    await _saveSecureCacheStorage.save(key: 'token', value: account.token);
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
}
