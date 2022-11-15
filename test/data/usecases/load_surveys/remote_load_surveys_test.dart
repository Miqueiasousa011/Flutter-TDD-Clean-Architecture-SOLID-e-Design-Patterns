import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';

import '../add_account/remote_add_account_test.mocks.dart';

class RemoteLoadSurveys {
  final HttpClient _client;
  final String _url;

  RemoteLoadSurveys({required HttpClient client, required String url})
      : _client = client,
        _url = url;

  Future load() async {
    _client.request(url: _url, method: 'get');
  }
}

@GenerateMocks([HttpClient])
void main() {
  late RemoteLoadSurveys sut;
  late MockHttpClient client;

  late String url;

  setUp(() {
    url = faker.internet.httpUrl();
    client = MockHttpClient();
    sut = RemoteLoadSurveys(client: client, url: url);
  });

  test('Should call HttpClient', () async {
    when(client.request(url: anyNamed('url'), method: anyNamed('method')))
        .thenAnswer((_) async => {'any': 'any'});

    await sut.load();

    verify(client.request(url: url, method: 'get'));
  });
}
