import 'package:faker/faker.dart';
import 'package:fordev/main/composites/composites.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'remote_load_surveys_with_local_fallback_test.mocks.dart';

@GenerateMocks([RemoteLoadSurveys, LocalLoadSurveys])
main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late MockRemoteLoadSurveys remote;
  late MockLocalLoadSurveys local;

  late List<SurveyEntity> remoteSurveys;
  late List<SurveyEntity> localSurveys;

  setUp(() {
    remoteSurveys = [
      SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(50),
        dateTime: faker.date.dateTime(),
        didAnswer: faker.randomGenerator.boolean(),
      )
    ];

    localSurveys = [
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

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(local.save(remoteSurveys)).called(1);
  });

  test('Should return remote dara', () async {
    final response = await sut.load();

    expect(response, remoteSurveys);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    when(remote.load()).thenThrow(DomainError.accessDenied);

    final future = sut.load();

    //Como é rethrow o erro repassado deve ser o mesmo do recebido
    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    when(remote.load()).thenThrow(DomainError.unexpected);
    when(local.load()).thenAnswer((_) async => []);

    await sut.load();

    verify(local.validate()).called(1);
    verify(local.load()).called(1);
  });

  test('Should return local surveys', () async {
    when(remote.load()).thenThrow(DomainError.unexpected);
    when(local.load()).thenAnswer((_) async => localSurveys);

    final result = await sut.load();

    expect(result, localSurveys);
  });

  test('Should throw UnexpectedError if remote and local throws', () async {
    when(remote.load()).thenThrow(DomainError.unexpected);
    when(local.load()).thenThrow(DomainError.unexpected);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
