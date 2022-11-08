import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'local_load_current_account_test.mocks.dart';

class LocalLoadCurrentAccount {
  final FetchSecureCacheStorage _fetchSecure;

  LocalLoadCurrentAccount({
    required FetchSecureCacheStorage fetchSecure,
  }) : _fetchSecure = fetchSecure;

  Future load() async {
    await _fetchSecure.fetchSecure('token');
  }
}

abstract class FetchSecureCacheStorage {
  Future fetchSecure(String key) async {}
}

@GenerateMocks([FetchSecureCacheStorage])
void main() {
  late LocalLoadCurrentAccount sut;
  late MockFetchSecureCacheStorage fetchSecure;

  setUp(() {
    fetchSecure = MockFetchSecureCacheStorage();
    sut = LocalLoadCurrentAccount(fetchSecure: fetchSecure);
  });

  test('Should call FetchSecureCacheStorage with correct value.', () async {
    when(fetchSecure.fetchSecure(any)).thenAnswer((_) async => '');

    await sut.load();

    verify(fetchSecure.fetchSecure('token'));
  });
}
