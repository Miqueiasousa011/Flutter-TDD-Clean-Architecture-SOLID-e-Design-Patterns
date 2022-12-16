import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/main/decorators/decorators.dart';

import 'authorize_http_client_decorator_test.mocks.dart';

@GenerateMocks([HttpClient, FetchSecureCacheStorage, DeleteSecureCacheStorage])
void main() {
  late AuthorizeHttpClientDecorator sut;
  late MockHttpClient httpClient;
  late MockFetchSecureCacheStorage fetchSecureCacheStorage;
  late MockDeleteSecureCacheStorage deleteSecureCacheStorage;

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

    deleteSecureCacheStorage = MockDeleteSecureCacheStorage();
    fetchSecureCacheStorage = MockFetchSecureCacheStorage();
    httpClient = MockHttpClient();
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      deleteSecureCacheStorage: deleteSecureCacheStorage,
      decoratee: httpClient,
    );

    when(fetchSecureCacheStorage.fetchSecure(any))
        .thenAnswer((_) async => token);
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

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
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
    when(fetchSecureCacheStorage.fetchSecure(any)).thenThrow(Exception());

    final future = sut.request(url: url, method: method);

    expect(future, throwsA(HttpError.forbiddenError));

    //Deletendo o token do local storage
    verify(deleteSecureCacheStorage.delete('token')).called(1);
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

  test('Should delete cache if HttpClient throws forbiddenError', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
      headers: anyNamed('headers'),
    )).thenThrow(HttpError.forbiddenError);

    final future = sut.request(url: url, method: method);
    expect(future, throwsA(HttpError.forbiddenError));

    //mockito aguarda a execução do método, já que não tem o await na linha 141
    await untilCalled(deleteSecureCacheStorage.delete('token'));
    verify(deleteSecureCacheStorage.delete('token')).called(1);
  });
}
