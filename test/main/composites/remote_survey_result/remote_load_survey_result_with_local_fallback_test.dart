import 'package:faker/faker.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/main/composites/composites.dart';

import 'remote_load_survey_result_with_local_fallback_test.mocks.dart';

@GenerateMocks([RemoteLoadSurveyResult, LocalLoadSurveyResult])
void main() {
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late MockRemoteLoadSurveyResult remote;
  late MockLocalLoadSurveyResult local;

  late String surveyId;
  late SurveyResultEntity surveyResultEntity;

  setUp(() {
    surveyResultEntity = SurveyResultEntity(
      surveyId: faker.guid.guid(),
      question: faker.randomGenerator.string(50),
      answers: [
        SurveyAnswerEntity(
          image: faker.internet.httpUrl(),
          answer: faker.randomGenerator.string(50),
          isCurrentAnswer: false,
          percent: 100,
        ),
      ],
    );

    surveyId = faker.guid.guid();
    local = MockLocalLoadSurveyResult();
    remote = MockRemoteLoadSurveyResult();
    sut = RemoteLoadSurveyResultWithLocalFallback(
      remoteLoadSurveyResult: remote,
      localLoadSurveyResult: local,
    );

    when(remote.loadBySurvey(surveyId: anyNamed('surveyId')))
        .thenAnswer((_) async => surveyResultEntity);
  });

  test('Should call remote load', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyId: surveyId, survey: surveyResultEntity))
        .called(1);
  });

  test('Should return remote survey result', () async {
    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(result, surveyResultEntity);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    when(remote.loadBySurvey(surveyId: anyNamed('surveyId')))
        .thenThrow(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local LoadBySurvey and Validate on remote error', () async {
    when(remote.loadBySurvey(surveyId: anyNamed('surveyId')))
        .thenThrow(Exception());

    when(local.loadBySurvey(surveyId: anyNamed('surveyId')))
        .thenAnswer((_) async => surveyResultEntity);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.validate(surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should return local survey result if remote load throws ', () async {
    when(remote.loadBySurvey(surveyId: anyNamed('surveyId')))
        .thenThrow(Exception());

    when(local.loadBySurvey(surveyId: surveyId))
        .thenAnswer((_) async => surveyResultEntity);

    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(result, surveyResultEntity);
  });

  test('Should throw UnexpectedError if remote and local throws', () async {
    when(remote.loadBySurvey(surveyId: anyNamed('surveyId')))
        .thenThrow(Exception());
    when(local.loadBySurvey(surveyId: anyNamed('surveyId')))
        .thenThrow(DomainError.unexpected);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
