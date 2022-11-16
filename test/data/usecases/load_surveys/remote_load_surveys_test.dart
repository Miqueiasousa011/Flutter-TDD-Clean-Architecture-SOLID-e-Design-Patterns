import 'package:faker/faker.dart';
import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';

import '../add_account/remote_add_account_test.mocks.dart';

class RemoteLoadSurveys {
  final HttpClient _client;
  final String _url;

  RemoteLoadSurveys({
    required HttpClient client,
    required String url,
  })  : _client = client,
        _url = url;

  Future<List<SurveyEntity>> load() async {
    final response = await _client.request(url: _url, method: 'get');
    List<SurveyEntity> surveys = [
      ...response.map((json) => RemoteSurveyModel.fromJson(json).toEntity())
    ];
    return surveys;
  }
}

@GenerateMocks([HttpClient])
void main() {
  late RemoteLoadSurveys sut;
  late MockHttpClient client;

  late String url;

  late List<Map<String, dynamic>> validData;

  setUp(() {
    validData = [
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'didAnswer': faker.randomGenerator.boolean(),
        'date': faker.date.dateTime().toIso8601String(),
      },
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'didAnswer': faker.randomGenerator.boolean(),
        'date': faker.date.dateTime().toIso8601String(),
      },
    ];

    url = faker.internet.httpUrl();
    client = MockHttpClient();
    sut = RemoteLoadSurveys(client: client, url: url);
  });

  test('Should call HttpClient', () async {
    when(client.request(url: anyNamed('url'), method: anyNamed('method')))
        .thenAnswer((_) async => validData);

    await sut.load();

    verify(client.request(url: url, method: 'get'));
  });

  test(
    'Should return surveys on 200',
    () async {
      when(client.request(url: anyNamed('url'), method: anyNamed('method')))
          .thenAnswer((_) async => validData);

      final result = await sut.load();

      expect(
        result,
        equals(
          [
            SurveyEntity(
              id: validData.first['id'],
              dateTime: DateTime.parse(validData.first['date']),
              question: validData.first['question'],
              didAnswer: validData.first['didAnswer'],
            ),
            SurveyEntity(
              id: validData.last['id'],
              dateTime: DateTime.parse(validData.last['date']),
              question: validData.last['question'],
              didAnswer: validData.last['didAnswer'],
            ),
          ],
        ),
      );
    },
  );
}
