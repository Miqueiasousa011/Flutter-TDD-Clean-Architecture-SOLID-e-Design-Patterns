import 'package:faker/faker.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';

import 'local_load_current_account_test.mocks.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccountUsecase {
  final FetchSecureCacheStorage _fetchSecure;

  LocalLoadCurrentAccount({
    required FetchSecureCacheStorage fetchSecure,
  }) : _fetchSecure = fetchSecure;

  @override
  Future<AccountEntity> load() async {
    final token = await _fetchSecure.fetchSecure('token');
    return AccountEntity(token: token);
  }
}

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

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
}
