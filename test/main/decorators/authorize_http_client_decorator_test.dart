import 'package:faker/faker.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'authorize_http_client_decorator_test.mocks.dart';

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage _secureCacheStorage;
  final HttpClient _decoratee;

  AuthorizeHttpClientDecorator({
    required FetchSecureCacheStorage secureCacheStorage,
    required HttpClient decoratee,
  })  : _secureCacheStorage = secureCacheStorage,
        _decoratee = decoratee;

  Future request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
  }) async {
    final token = await _secureCacheStorage.fetchSecure('token');

    final authorizedHeader = {'x-access-token': token ?? ''};

    await _decoratee.request(
      url: url,
      method: method,
      body: body,
      headers: authorizedHeader,
    );
  }
}

@GenerateMocks([HttpClient, FetchSecureCacheStorage])
void main() {
  late AuthorizeHttpClientDecorator sut;
  late MockHttpClient httpClient;
  late MockFetchSecureCacheStorage secureCacheStorage;

  late String url;
  late String method;
  late Map<String, dynamic> body;

  late String token;

  setUp(() {
    token = faker.guid.guid();
    url = faker.internet.httpUrl();
    method = 'any';
    body = {'any': 'any'};

    secureCacheStorage = MockFetchSecureCacheStorage();
    httpClient = MockHttpClient();
    sut = AuthorizeHttpClientDecorator(
      secureCacheStorage: secureCacheStorage,
      decoratee: httpClient,
    );

    when(secureCacheStorage.fetchSecure(any)).thenAnswer((_) async => token);
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => '');

    await sut.request(
      url: url,
      method: method,
      body: body,
    );

    verify(secureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
        headers: {'x-access-token': token})).thenAnswer((_) async => '');

    await sut.request(url: url, method: method, body: body);

    verify(httpClient.request(
        url: url,
        method: method,
        body: body,
        headers: {'x-access-token': token})).called(1);
  });
}
