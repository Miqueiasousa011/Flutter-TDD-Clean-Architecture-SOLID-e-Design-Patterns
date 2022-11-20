import 'package:fordev/data/models/local_survey_model.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'local_load_surveys_test.mocks.dart';

class LocalLoadSurveys {
  final FetchCacheStorage _fetchCacheStorage;

  LocalLoadSurveys({required FetchCacheStorage fetchCacheStorage})
      : _fetchCacheStorage = fetchCacheStorage;

  Future<List<SurveyEntity>> load() async {
    try {
      final response = await _fetchCacheStorage.fetch('surveys');

      if (response?.isEmpty != false) {
        throw Exception();
      }

      return response
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

abstract class FetchCacheStorage {
  Future<dynamic> fetch(String key);
}

@GenerateMocks([FetchCacheStorage])
void main() {
  late MockFetchCacheStorage fetchCacheStorage;
  late LocalLoadSurveys sut;

  late List<SurveyEntity> response;
  late List<Map<String, dynamic>> fetchResponse;

  setUp(() {
    fetchCacheStorage = MockFetchCacheStorage();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);

    response = [
      SurveyEntity(
        id: '1',
        question: 'question',
        dateTime: DateTime(2000, 2, 2),
        didAnswer: false,
      ),
      SurveyEntity(
        id: '2',
        question: 'question 2',
        dateTime: DateTime(2000, 12, 2),
        didAnswer: true,
      ),
    ];

    fetchResponse = [
      {
        'id': '1',
        'question': 'question',
        'date': '2000-02-02',
        'didAnswer': false
      },
      {
        'id': '2',
        'question': 'question 2',
        'date': '2000-12-02',
        'didAnswer': true
      },
    ];
  });

  test('Should call FetchCacheStorage with correct key', () async {
    when(fetchCacheStorage.fetch('surveys'))
        .thenAnswer((_) async => fetchResponse);

    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });

  test('Should return list of surveys on success', () async {
    when(fetchCacheStorage.fetch('surveys'))
        .thenAnswer((_) async => fetchResponse);

    final result = await sut.load();

    expect(result, equals(response));
  });

  test('Should throw UnexpectedError if cash is empty', () async {
    when(fetchCacheStorage.fetch(any)).thenAnswer((_) async => []);

    final result = sut.load();

    expect(result, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cash is null', () async {
    when(fetchCacheStorage.fetch(any)).thenAnswer((_) async => null);

    final result = sut.load();

    expect(result, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cash is invalid', () async {
    when(fetchCacheStorage.fetch(any)).thenAnswer((_) async => [
          {
            'id': '1',
            'question': 'question',
            'date': 'invalid',
            'didAnswer': false
          },
        ]);

    final result = sut.load();

    expect(result, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cash is incomplete', () async {
    when(fetchCacheStorage.fetch(any)).thenAnswer((_) async => [
          {
            'id': '1',
            'date': '2000-02-02',
          },
        ]);

    final result = sut.load();

    expect(result, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if fetchCacheStorage throws', () async {
    when(fetchCacheStorage.fetch(any)).thenThrow((_) => Exception());

    final result = sut.load();

    expect(result, throwsA(DomainError.unexpected));
  });
}
