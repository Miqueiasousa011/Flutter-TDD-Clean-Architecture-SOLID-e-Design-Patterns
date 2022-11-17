import 'package:faker/faker.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'authorize_http_client_decorator_test.mocks.dart';

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage _secureCacheStorage;

  AuthorizeHttpClientDecorator({
    required FetchSecureCacheStorage secureCacheStorage,
  }) : _secureCacheStorage = secureCacheStorage;

  Future request() async {
    await _secureCacheStorage.fetchSecure('token');
  }
}

@GenerateMocks([HttpClient, FetchSecureCacheStorage])
void main() {
  late AuthorizeHttpClientDecorator sut;
  late MockHttpClient httpClient;
  late MockFetchSecureCacheStorage secureCacheStorage;

  late String token;

  setUp(() {
    token = faker.guid.guid();
    secureCacheStorage = MockFetchSecureCacheStorage();
    httpClient = MockHttpClient();
    sut = AuthorizeHttpClientDecorator(secureCacheStorage: secureCacheStorage);
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    when(secureCacheStorage.fetchSecure(any)).thenAnswer((_) async => token);

    await sut.request();

    verify(secureCacheStorage.fetchSecure('token')).called(1);
  });
}
