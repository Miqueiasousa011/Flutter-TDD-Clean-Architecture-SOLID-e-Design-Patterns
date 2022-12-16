import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/ui/pages/survey_result/survey_result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'getx_survey_result_presenter_test.mocks.dart';

@GenerateMocks([LoadSurveyResultUsecase])
void main() {
  late GetxSurveyResultPresenter sut;
  late MockLoadSurveyResultUsecase loadSurveyResult;

  late SurveyResultEntity surveyResultEntity;
  late SurveyResultViewModel surveyResultViewModel;

  late String surveyId;

  setUp(() {
    loadSurveyResult = MockLoadSurveyResultUsecase();

    surveyId = faker.guid.guid();

    sut = GetxSurveyResultPresenter(
      surveyId: surveyId,
      loadSurveyResult: loadSurveyResult,
    );

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

    surveyResultViewModel = SurveyResultViewModel(
      surveyId: surveyResultEntity.surveyId,
      question: surveyResultEntity.question,
      answers: surveyResultEntity.answers
          .map(
            (e) => SurveyAnswerViewModel(
              image: e.image ?? '',
              answer: e.answer,
              isCurrentAnswer: e.isCurrentAnswer,
              percent: '${e.percent}%',
            ),
          )
          .toList(),
    );

    when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')))
        .thenAnswer((_) async => surveyResultEntity);
  });

  test('Should call loadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingController, emitsInOrder([true, false]));

    sut.surveyResultController.listen(
        expectAsync1((result) => expect(result, surveyResultViewModel)));

    await sut.loadData();
  });

  test('Should emit correct events on failure', () async {
    when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')))
        .thenThrow(DomainError.unexpected);

    expectLater(sut.isLoadingController, emitsInOrder([true, false]));

    sut.surveyResultController.listen(null,
        onError: expectAsync1(
            (error) => expect(error, DomainError.unexpected.description)));

    await sut.loadData();
  });

  test('Should logout if accessDeniedError', () async {
    when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')))
        .thenThrow(DomainError.accessDenied);

    expectLater(sut.isLoadingController, emitsInOrder([true, false]));

    expectLater(sut.isSessionExpiredStream, emits(true));

    sut.loadData();
  });
}
