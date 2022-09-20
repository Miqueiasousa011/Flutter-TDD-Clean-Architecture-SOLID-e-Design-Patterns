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

  Future auth() async {
    await _httpClient.request(url: _url);
  }
}

abstract class HttpClient {
  Future request({required String url});
}

@GenerateMocks([HttpClient])
void main() {
  late RemoteAuthenticationUsecase sut;
  late MockHttpClient client;
  late String url;

  setUp(() {
    url = faker.internet.httpUrl();
    client = MockHttpClient();
    sut = RemoteAuthenticationUsecase(url: url, httpClient: client);
  });

  test('Should call HttpClient with correct url', () async {
    when(sut.auth()).thenAnswer((_) async => {});

    await sut.auth();

    verify(client.request(url: url));
  });
}
