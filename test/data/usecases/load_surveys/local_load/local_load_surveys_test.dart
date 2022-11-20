import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/load_surveys/local_load_surveys.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'local_load_surveys_test.mocks.dart';

@GenerateMocks([CacheStorage])
void main() {
  group('load', () {
    late MockCacheStorage cacheStorage;
    late LocalLoadSurveys sut;

    late List<SurveyEntity> response;
    late List<Map<String, dynamic>> fetchResponse;

    setUp(() {
      cacheStorage = MockCacheStorage();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);

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

    test('Should call cacheStorage with correct key', () async {
      when(cacheStorage.fetch('surveys'))
          .thenAnswer((_) async => fetchResponse);

      await sut.load();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return list of surveys on success', () async {
      when(cacheStorage.fetch('surveys'))
          .thenAnswer((_) async => fetchResponse);

      final result = await sut.load();

      expect(result, equals(response));
    });

    test('Should throw UnexpectedError if cash is empty', () async {
      when(cacheStorage.fetch(any)).thenAnswer((_) async => []);

      final result = sut.load();

      expect(result, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cash is null', () async {
      when(cacheStorage.fetch(any)).thenAnswer((_) async => null);

      final result = sut.load();

      expect(result, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cash is invalid', () async {
      when(cacheStorage.fetch(any)).thenAnswer((_) async => [
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
      when(cacheStorage.fetch(any)).thenAnswer((_) async => [
            {
              'id': '1',
              'date': '2000-02-02',
            },
          ]);

      final result = sut.load();

      expect(result, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cacheStorage throws', () async {
      when(cacheStorage.fetch(any)).thenThrow((_) => Exception());

      final result = sut.load();

      expect(result, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    late MockCacheStorage cacheStorage;
    late LocalLoadSurveys sut;

    late List<SurveyEntity> response;
    late List<Map<String, dynamic>> fetchResponse;

    setUp(() {
      cacheStorage = MockCacheStorage();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);

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

    test('Should call cacheStorage with correct key', () async {
      when(cacheStorage.fetch('surveys'))
          .thenAnswer((_) async => fetchResponse);

      await sut.validate();

      verify(cacheStorage.fetch('surveys')).called(1);
    });
  });
}
