import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/data/cache/cache.dart';

import 'local_load_survey_result_test.mocks.dart';

@GenerateMocks([CacheStorage])
void main() {
  late LocalLoadSurveyResult sut;
  late MockCacheStorage cacheStorage;
  late String surveyId;
  late Map<String, dynamic> data;
  late SurveyResultEntity surveyResultEntity;

  setUp(() {
    surveyId = faker.guid.guid();
    data = {
      'surveyId': faker.guid.guid(),
      'question': faker.randomGenerator.string(40),
      'answers': [
        {
          'image': faker.internet.httpUrl(),
          'answer': faker.randomGenerator.string(50),
          'isCurrentAccountAnswer': 'true',
          'percent': '10',
        },
        {
          'image': faker.internet.httpUrl(),
          'answer': faker.randomGenerator.string(50),
          'isCurrentAccountAnswer': 'true',
          'percent': '10',
        },
      ]
    };

    surveyResultEntity = SurveyResultEntity(
      surveyId: data['surveyId'],
      question: data['question'],
      answers: data['answers']
          .map<SurveyAnswerEntity>(
            (e) => SurveyAnswerEntity(
              image: e['image'],
              answer: e['answer'],
              isCurrentAnswer: true,
              percent: 10,
            ),
          )
          .toList(),
    );

    cacheStorage = MockCacheStorage();
    sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
  });

  group('load', () {
    test('Should call cacheStorage with correct key', () async {
      when(cacheStorage.fetch(any)).thenAnswer((_) async => data);

      await sut.loadBySurvey(surveyId: surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return a survey result on success', () async {
      when(cacheStorage.fetch(any)).thenAnswer((_) async => data);

      final result = await sut.loadBySurvey(surveyId: surveyId);

      expect(result, surveyResultEntity);
    });

    test('Should throw UnexpectedError if cash is null', () async {
      when(cacheStorage.fetch(any)).thenAnswer((_) async => null);

      final result = sut.loadBySurvey(surveyId: surveyId);

      expect(result, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cash is empty', () async {
      when(cacheStorage.fetch(any)).thenAnswer((_) async => {});

      final result = sut.loadBySurvey(surveyId: surveyId);

      expect(result, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cash is invalid', () async {
      when(cacheStorage.fetch(any)).thenAnswer(
        (_) async => {
          'surveyId': '1',
          'question': 'question',
          'answer': 'invalid',
        },
      );

      final result = sut.loadBySurvey(surveyId: surveyId);

      expect(result, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cash is incomplete', () async {
      when(cacheStorage.fetch(any)).thenAnswer(
        (_) async => {
          'surveyId': '1',
          'question': '2000-02-02',
        },
      );

      final result = sut.loadBySurvey(surveyId: surveyId);

      expect(result, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cacheStorage throws', () async {
      when(cacheStorage.fetch(any)).thenThrow((_) => Exception());

      final result = sut.loadBySurvey(surveyId: surveyId);

      expect(result, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('Should call cacheStorage with correct key', () async {
      when(cacheStorage.fetch('survey_result/$surveyId'))
          .thenAnswer((_) async => data);

      await sut.validate(surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if isValid', () async {
      when(cacheStorage.fetch(any)).thenAnswer(
        (_) async => {
          'surveyId': faker.guid.guid(),
          'questions': faker.randomGenerator.string(40),
          'answers': [
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.randomGenerator.string(50),
              'isCurrentAccountAnswer': 'true',
              'percent': '10',
            },
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.randomGenerator.string(50),
              'isCurrentAccountAnswer': 'true',
              'percent': '10',
            },
          ]
        },
      );

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      when(cacheStorage.fetch(any)).thenAnswer(
        (_) async => {
          'surveyId': faker.guid.guid(),
          'question': faker.randomGenerator.string(40),
          'answers': [
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.randomGenerator.string(50),
            },
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.randomGenerator.string(50),
            },
          ]
        },
      );

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if CacheStorage throws', () async {
      when(cacheStorage.fetch(any)).thenThrow(Exception());

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    test('Should call cacheStorage with correct values', () async {
      final map = <String, dynamic>{
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(40),
        'answers': [
          {
            'image': null,
            'answer': faker.randomGenerator.string(50),
            'isCurrentAccountAnswer': 'true',
            'percent': '10',
          },
        ]
      };

      final surveyEntity = SurveyResultEntity(
        surveyId: map['surveyId'],
        question: map['question'],
        answers: [
          SurveyAnswerEntity(
            image: map['answers'][0]['image'],
            answer: map['answers'][0]['answer'],
            isCurrentAnswer: true,
            percent: 10,
          )
        ],
      );

      const id = '467b7823-018c-df58-4a5a-0c4916c6bec0';

      await sut.save(survey: surveyEntity, surveyId: id);

      verify(cacheStorage.save(key: 'survey_result/$id', value: map)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () {
      when(cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')))
          .thenThrow(Exception());

      final future = sut.save(survey: surveyResultEntity, surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
