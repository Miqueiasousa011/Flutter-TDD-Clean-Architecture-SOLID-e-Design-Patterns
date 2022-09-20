import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';

import 'remote_authentication_usecase_test.mocks.dart';

class RemoteAuthenticationUsecase {
  final String _url;
  final HttpClient _httpClient;

  RemoteAuthenticationUsecase({
    required String url,
    required HttpClient httpClient,
  })  : _url = url,
        _httpClient = httpClient;

  Future auth(AuthenticationParams params) async {
    await _httpClient.request(
      url: _url,
      method: 'post',
      body: {
        'email': params.email,
        'password': params.password,
      },
    );
  }
}

abstract class HttpClient {
  Future request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  });
}

@GenerateMocks([HttpClient])
void main() {
  late RemoteAuthenticationUsecase sut;
  late MockHttpClient client;
  late AuthenticationParams params;
  late String url;
  late String email;
  late String password;
  late Map<String, dynamic> requestBody;

  setUp(() {
    url = faker.internet.httpUrl();

    email = faker.internet.email();
    password = faker.internet.password();
    params = AuthenticationParams(email: email, password: password);

    requestBody = {'email': params.email, 'password': params.password};
    client = MockHttpClient();
    sut = RemoteAuthenticationUsecase(url: url, httpClient: client);
  });

  test('Should call HttpClient with correct values', () async {
    when(client.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => {});

    await sut.auth(params);

    verify(client.request(url: url, method: 'post', body: requestBody));
  });
}
