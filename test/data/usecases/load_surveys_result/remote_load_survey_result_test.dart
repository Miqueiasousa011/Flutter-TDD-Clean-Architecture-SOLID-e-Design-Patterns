import 'package:faker/faker.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';

import 'remote_load_survey_result_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late String url;
  late MockHttpClient client;
  late RemoteLoadSurveyResult sut;
  late SurveyResultEntity surveyResultEntity;
  late Map<String, dynamic> surveyResult;

  setUp(() {
    url = faker.internet.httpUrl();
    client = MockHttpClient();
    sut = RemoteLoadSurveyResult(url: url, client: client);

    surveyResult = {
      'surveyId': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'answers': [
        {
          'image': faker.internet.httpUrl(),
          'answer': faker.randomGenerator.string(110),
          'count': faker.randomGenerator.integer(50),
          'percent': faker.randomGenerator.integer(100),
          'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
        }
      ],
      'date': faker.date.dateTime().toIso8601String(),
    };

    surveyResultEntity = SurveyResultEntity(
      surveyId: surveyResult['surveyId'],
      question: surveyResult['question'],
      answers: surveyResult['answers']
          .map<SurveyAnswerEntity>(
            (result) => SurveyAnswerEntity(
              image: result['image'],
              answer: result['answer'],
              isCurrentAnswer: result['isCurrentAccountAnswer'],
              percent: result['percent'],
            ),
          )
          .toList(),
    );
  });

  test('Should call HttpClient', () async {
    when(client.request(url: anyNamed('url'), method: anyNamed('method')))
        .thenAnswer((_) async => surveyResult);

    await sut.loadBySurvey();

    verify(client.request(url: url, method: 'get')).called(1);
  });

  test('Should return survey result on 200', () async {
    when(client.request(url: anyNamed('url'), method: anyNamed('method')))
        .thenAnswer((_) async => surveyResult);

    final result = await sut.loadBySurvey();

    expect(result, equals(surveyResultEntity));
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    when(client.request(url: anyNamed('url'), method: anyNamed('method')))
        .thenAnswer((_) async => {
              'surveyId': faker.guid.guid(),
              'questions': faker.randomGenerator.string(50),
              'answer': [
                {
                  'image': faker.internet.httpUrl(),
                  'answer': faker.randomGenerator.string(110),
                  'count': faker.randomGenerator.integer(50),
                  'percent': faker.randomGenerator.integer(100),
                  'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
                }
              ],
              'date': faker.date.dateTime().toIso8601String(),
            });

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpextedError if HttpClient returns 404', () {
    when(client.request(url: anyNamed('url'), method: anyNamed('method')))
        .thenThrow(HttpError.badRequest);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () {
    when(client.request(url: anyNamed('url'), method: anyNamed('method')))
        .thenThrow(HttpError.serverError);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw  AcessDenidError if HttpClient returns 403', () {
    when(client.request(url: anyNamed('url'), method: anyNamed('method')))
        .thenThrow(HttpError.forbiddenError);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
