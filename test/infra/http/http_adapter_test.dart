import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter {
  final Client _client;

  HttpAdapter(this._client);

  request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    await _client.post(Uri.parse(url));
  }
}

@GenerateMocks([Client])
void main() {
  late HttpAdapter sut;
  late MockClient httpClient;
  late String url;
  late Uri uri;

  setUp(() {
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
    httpClient = MockClient();
    sut = HttpAdapter(httpClient);
  });

  group('post', () {
    test('Should call post with correct values', () async {
      when(httpClient.post(uri)).thenAnswer((_) async => Response('{}', 200));

      await sut.request(url: url, method: 'post');

      verify(httpClient.post(uri));
    });
  });
}
