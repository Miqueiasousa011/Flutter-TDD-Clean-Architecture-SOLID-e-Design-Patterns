import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/usecases/load_surveys_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/usecases/usecases.dart';

import 'remote_load_surveys_with_local_fallback_test.mocks.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveysUsecase {
  final RemoteLoadSurveys _remote;
  final LocalLoadSurveys _local;

  RemoteLoadSurveysWithLocalFallback(
      {required RemoteLoadSurveys remote, required LocalLoadSurveys local})
      : _remote = remote,
        _local = local;

  @override
  Future<List<SurveyEntity>> load() async {
    final surveys = await _remote.load();

    await _local.save(surveys);

    return surveys;
  }
}

@GenerateMocks([RemoteLoadSurveys, LocalLoadSurveys])
main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late MockRemoteLoadSurveys remote;
  late MockLocalLoadSurveys local;

  late List<SurveyEntity> remoteSurveys;

  setUp(() {
    remoteSurveys = [
      SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(50),
        dateTime: faker.date.dateTime(),
        didAnswer: faker.randomGenerator.boolean(),
      )
    ];

    remote = MockRemoteLoadSurveys();
    local = MockLocalLoadSurveys();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);

    when(remote.load()).thenAnswer((_) async => remoteSurveys);
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });

  test('Should call local save with remote dara', () async {
    await sut.load();

    verify(local.save(remoteSurveys)).called(1);
  });

  test('Should return remote dara', () async {
    final response = await sut.load();

    expect(response, remoteSurveys);
  });
}
