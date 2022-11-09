import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/data/cache/cache.dart';

import 'local_save_current_account_test.mocks.dart';

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

    verify(saveSecureCacheStorage.saveSecure(key: 'token', value: token));
  });

  test('Should throw  UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    when(saveSecureCacheStorage.saveSecure(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());

    final future = sut.save(accountEntity);

    expect(future, throwsA(DomainError.unexpected));
  });
}
