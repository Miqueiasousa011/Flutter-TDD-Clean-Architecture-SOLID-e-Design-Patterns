import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../main/decorators/authorize_http_client_decorator_test.mocks.dart';

class RemoteSaveSurveyResult {
  final HttpClient _httpClient;
  final String _url;

  RemoteSaveSurveyResult({
    required HttpClient httpClient,
    required String url,
  })  : _httpClient = httpClient,
        _url = url;

  Future save({required String answer}) async {
    await _httpClient.request(
      url: _url,
      method: 'put',
      body: {'answer': answer},
    );
  }
}

@GenerateMocks([HttpClient])
void main() {
  late RemoteSaveSurveyResult sut;
  late MockHttpClient httpClient;

  late String url;
  late Map<String, dynamic> body;

  setUp(() {
    body = {'answer': 'any_answer'};
    url = faker.internet.httpUrl();
    httpClient = MockHttpClient();
    sut = RemoteSaveSurveyResult(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => 'any');

    await sut.save(answer: 'any_answer');

    verify(httpClient.request(
      url: url,
      method: 'put',
      body: body,
    )).called(1);
  });
}
