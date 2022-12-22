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

@GenerateMocks([LoadSurveyResultUsecase, SaveSurveyResultUsecase])
void main() {
  late GetxSurveyResultPresenter sut;
  late MockLoadSurveyResultUsecase loadSurveyResult;
  late MockSaveSurveyResultUsecase saveSurveyResult;

  late SurveyResultEntity loadSurveyResultEntity;
  late SurveyResultViewModel surveyResultViewModel;

  late String surveyId;

  setUp(() {
    loadSurveyResult = MockLoadSurveyResultUsecase();
    saveSurveyResult = MockSaveSurveyResultUsecase();

    surveyId = faker.guid.guid();

    sut = GetxSurveyResultPresenter(
      surveyId: surveyId,
      loadSurveyResult: loadSurveyResult,
      saveSurveyResult: saveSurveyResult,
    );

    loadSurveyResultEntity = SurveyResultEntity(
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
      surveyId: loadSurveyResultEntity.surveyId,
      question: loadSurveyResultEntity.question,
      answers: loadSurveyResultEntity.answers
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
        .thenAnswer((_) async => loadSurveyResultEntity);
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

  group('save', () {
    late String answer;
    late SurveyResultEntity saveSurveyResultEntity;

    setUp(() {
      answer = 'any_answer';

      saveSurveyResultEntity = SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.randomGenerator.string(50),
        answers: [
          SurveyAnswerEntity(
            image: faker.internet.httpUrl(),
            answer: answer,
            isCurrentAnswer: false,
            percent: 100,
          ),
        ],
      );

      when(saveSurveyResult.save(answer: anyNamed('answer')))
          .thenAnswer((_) async => saveSurveyResultEntity);
    });

    test('Should call SaveResult on save', () async {
      await sut.save(answer: answer);

      verify(saveSurveyResult.save(answer: answer));
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingController, emitsInOrder([true, false]));

      sut.surveyResultController.listen(expectAsync1((saveResult) => expect(
            saveResult,
            SurveyResultViewModel(
              surveyId: saveSurveyResultEntity.surveyId,
              question: saveSurveyResultEntity.question,
              answers: saveSurveyResultEntity.answers
                  .map((e) => SurveyAnswerViewModel(
                      image: e.image ?? '',
                      answer: answer,
                      isCurrentAnswer: e.isCurrentAnswer,
                      percent: '${e.percent}'))
                  .toList(),
            ),
          )));

      await sut.save(answer: answer);
    });

    test('Should emit correct events on failure', () async {
      when(saveSurveyResult.save(answer: anyNamed('answer')))
          .thenThrow(DomainError.unexpected);

      expectLater(sut.isLoadingController, emitsInOrder([true, false]));

      sut.surveyResultController.listen(null,
          onError: expectAsync1(
              (error) => expect(error, DomainError.unexpected.description)));

      await sut.save(answer: answer);
    });

    test('Should logout if accessDeniedError', () async {
      when(saveSurveyResult.save(answer: anyNamed('answer')))
          .thenThrow(DomainError.accessDenied);

      expectLater(sut.isLoadingController, emitsInOrder([true, false]));

      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.save(answer: answer);
    });
  });
}
