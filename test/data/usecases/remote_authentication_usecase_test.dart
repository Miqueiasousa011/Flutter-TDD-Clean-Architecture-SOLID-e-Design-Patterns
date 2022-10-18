import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';

import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/data/http/http.dart';

import 'remote_authentication_usecase_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteAuthenticationUsecase sut;
  late MockHttpClient client;
  late AuthenticationParams params;
  late String url;
  late String email;
  late String password;
  late Map<String, dynamic> requestBody;
  late Map<String, dynamic> response;

  setUp(() {
    url = faker.internet.httpUrl();

    email = faker.internet.email();
    password = faker.internet.password();
    params = AuthenticationParams(email: email, password: password);

    requestBody = {'email': params.email, 'password': params.password};
    response = {'accessToken': faker.guid.guid()};

    client = MockHttpClient();
    sut = RemoteAuthenticationUsecase(url: url, httpClient: client);
  });

  test('Should call HttpClient with correct values', () async {
    when(client.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => response);

    await sut.auth(params);

    verify(client.request(url: url, method: 'post', body: requestBody));
  });

  test('Should throw UnexpectedError if httpClient returns 400', () {
    when(client.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final result = sut.auth(params);

    expect(result, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if httpClient returns 404', () {
    when(client.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    final result = sut.auth(params);

    expect(result, throwsA(DomainError.unexpected));
  });

  test('Should throw ServerError if HttpClient returns 500', () {
    when(client.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    final result = sut.auth(params);

    expect(result, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentials if HttpClient returns 4001 ', () {
    when(client.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);

    final result = sut.auth(params);

    expect(result, throwsA(DomainError.invalidCredentialsError));
  });

  test('Should return Account if HttpClient returns 200', () async {
    final accessToken = faker.guid.guid();

    when(client.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {'accessToken': accessToken});

    final account = await sut.auth(params);

    expect(account.token, equals(accessToken));
  });
}
