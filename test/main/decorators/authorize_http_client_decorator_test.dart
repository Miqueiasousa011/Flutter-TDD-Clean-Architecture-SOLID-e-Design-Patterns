import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/main/decorators/decorators.dart';

import 'authorize_http_client_decorator_test.mocks.dart';

@GenerateMocks([HttpClient, FetchSecureCacheStorage])
void main() {
  late AuthorizeHttpClientDecorator sut;
  late MockHttpClient httpClient;
  late MockFetchSecureCacheStorage secureCacheStorage;

  late String url;
  late String method;
  late Map<String, dynamic> body;
  late String response;
  late String token;

  setUp(() {
    token = faker.guid.guid();
    url = faker.internet.httpUrl();
    method = 'any';
    body = {'any': 'any'};
    response = faker.randomGenerator.string(10);

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
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => '');

    //header não passado
    await sut.request(url: url, method: method, body: body);

    //Verifica se foi adicionado o token no header
    verify(httpClient.request(
        url: url,
        method: method,
        body: body,
        headers: {'x-access-token': token})).called(1);

    //Adicionando o token a um header existente
    await sut.request(
        url: url,
        method: method,
        body: body,
        headers: {'any_header': 'any_value'});

    verify(httpClient.request(
            url: url,
            method: method,
            body: body,
            headers: {'x-access-token': token, 'any_header': 'any_value'}))
        .called(1);
  });

  test('Should return same result as decoratee', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => response);

    final result = await sut.request(url: url, method: method);

    expect(result, response);
  });

  test('Should throw ForbiddenError if FetchSecureCacheStorage throws',
      () async {
    when(secureCacheStorage.fetchSecure(any)).thenThrow(Exception());

    final future = sut.request(url: url, method: method);

    expect(future, throwsA(HttpError.forbiddenError));
  });

  test('Should rethrow  if HttpClient throws', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
      headers: anyNamed('headers'),
    )).thenThrow(HttpError.badRequest);

    final future = sut.request(url: url, method: method);

    expect(future, throwsA(HttpError.badRequest));
  });
}
