import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'remote_add_account_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteAddAccount sut;
  late AddAccountParams addAccountParams;
  late MockHttpClient httpClient;
  late String url;

  setUp(() {
    addAccountParams = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: 'fake_password',
      passwordConfirmation: 'fake_password',
    );
    url = faker.internet.httpUrl();

    httpClient = MockHttpClient();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => {'any': 'any'});

    await sut.add(addAccountParams);

    verify(
      httpClient.request(
        url: url,
        method: 'post',
        body: {
          'name': addAccountParams.name,
          'email': addAccountParams.email,
          'password': addAccountParams.password,
          'passwordConfirmation': addAccountParams.passwordConfirmation,
        },
      ),
    );
  });

  test('Should throw UnexpectedError if httpClient returns 400 ', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.badRequest);

    final future = sut.add(addAccountParams);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if httpClient returns 404 ', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.notFound);

    final future = sut.add(addAccountParams);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if httpClient returns 500 ', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.serverError);

    final future = sut.add(addAccountParams);

    expect(future, throwsA(DomainError.unexpected));
  });
}
