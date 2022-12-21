import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/usecases/usecases.dart';

import 'remote_load_survey_result_with_local_fallback_test.mocks.dart';

class RemoteLoadSurveyResultWithLocalFallback {
  final RemoteLoadSurveyResult _remoteLoadSurveyResult;
  final LocalLoadSurveyResult _localLoadSurveyResult;

  RemoteLoadSurveyResultWithLocalFallback({
    required RemoteLoadSurveyResult remoteLoadSurveyResult,
    required LocalLoadSurveyResult localLoadSurveyResult,
  })  : _remoteLoadSurveyResult = remoteLoadSurveyResult,
        _localLoadSurveyResult = localLoadSurveyResult;

  Future<SurveyResultEntity> loadBySurvey({String? surveyId}) async {
    final data = await _remoteLoadSurveyResult.loadBySurvey(surveyId: surveyId);
    await _localLoadSurveyResult.save(surveyId: surveyId!, survey: data);
    return data;
  }
}

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

    verify(remote.loadBySurvey()).called(1);
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
}
