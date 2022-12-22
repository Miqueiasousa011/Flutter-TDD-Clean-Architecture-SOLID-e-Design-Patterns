import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/models/remote_survey_result_model.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/save_survey_result.dart';

import '../../../main/decorators/authorize_http_client_decorator_test.mocks.dart';

class RemoteSaveSurveyResult implements SaveSurveyResultUsecase {
  final HttpClient _httpClient;
  final String _url;

  RemoteSaveSurveyResult({
    required HttpClient httpClient,
    required String url,
  })  : _httpClient = httpClient,
        _url = url;

  @override
  Future<SurveyResultEntity> save({required String answer}) async {
    try {
      final response = await _httpClient.request(
        url: _url,
        method: 'put',
        body: {'answer': answer},
      );
      return RemoteSurveyResultModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbiddenError
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}

@GenerateMocks([HttpClient])
void main() {
  late RemoteSaveSurveyResult sut;
  late MockHttpClient httpClient;

  late String url;
  late Map<String, dynamic> body;

  late Map<String, dynamic> response;

  setUp(() {
    body = {'answer': 'any_answer'};
    url = faker.internet.httpUrl();
    httpClient = MockHttpClient();
    sut = RemoteSaveSurveyResult(httpClient: httpClient, url: url);

    response = {
      'surveyId': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'answers': [
        {
          'image': faker.internet.httpUrl(),
          'answer': 'any_answer',
          'count': faker.randomGenerator.integer(50),
          'percent': 10,
          'isCurrentAccountAnswer': false,
        }
      ],
      'date': faker.date.dateTime().toIso8601String(),
    };

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => response);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.save(answer: 'any_answer');

    verify(httpClient.request(
      url: url,
      method: 'put',
      body: body,
    )).called(1);
  });

  test('Should return survey result on 200', () async {
    final result = await sut.save(answer: 'any_answer');

    final entity = SurveyResultEntity(
      surveyId: response['surveyId'],
      question: response['question'],
      answers: [
        SurveyAnswerEntity(
          image: response['answers'][0]['image'],
          answer: response['answers'][0]['answer'],
          isCurrentAnswer: false,
          percent: 10,
        )
      ],
    );

    expect(result, equals(entity));
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
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

    final future = sut.save(answer: 'any_answer');

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpextedError if HttpClient returns 404', () {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final future = sut.save(answer: 'any_answer');

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    final future = sut.save(answer: 'any_answer');

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw  AcessDenidError if HttpClient returns 403', () {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.forbiddenError);

    final future = sut.save(answer: 'any_answer');

    expect(future, throwsA(DomainError.accessDenied));
  });
}
