import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'local_load_current_account_test.mocks.dart';

@GenerateMocks([FetchSecureCacheStorage])
void main() {
  late LocalLoadCurrentAccount sut;
  late MockFetchSecureCacheStorage fetchSecure;
  late AccountEntity accountEntity;

  setUp(() {
    accountEntity = AccountEntity(token: faker.guid.guid());
    fetchSecure = MockFetchSecureCacheStorage();
    sut = LocalLoadCurrentAccount(fetchSecure: fetchSecure);
  });

  test('Should call FetchSecureCacheStorage with correct value.', () async {
    when(fetchSecure.fetchSecure(any)).thenAnswer((_) async => '');

    await sut.load();

    verify(fetchSecure.fetchSecure('token'));
  });

  test('Should return an AccountAntity', () async {
    when(fetchSecure.fetchSecure('token'))
        .thenAnswer((_) async => accountEntity.token);

    final result = await sut.load();

    expect(result, equals(accountEntity));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage throws',
      () async {
    when(fetchSecure.fetchSecure('token')).thenThrow(Exception());

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
