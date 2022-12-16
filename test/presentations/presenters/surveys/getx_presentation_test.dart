import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/load_surveys_usecase.dart';
import 'package:fordev/presentation/presenters/getx_surveys_presenter.dart';
import 'package:fordev/ui/helpers/ui_error.dart';
import 'package:fordev/ui/pages/pages.dart';

import 'getx_presentation_test.mocks.dart';

@GenerateMocks([LoadSurveysUsecase])
void main() {
  late GetxSurveysPresenter sut;
  late MockLoadSurveysUsecase loadSurveys;

  late List<SurveyEntity> surveys;

  setUp(() {
    surveys = [
      SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(100),
        dateTime: DateTime(2020, 02, 20),
        didAnswer: faker.randomGenerator.boolean(),
      ),
      SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(100),
        dateTime: DateTime(2018, 10, 03),
        didAnswer: faker.randomGenerator.boolean(),
      ),
    ];

    loadSurveys = MockLoadSurveysUsecase();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);

    when(loadSurveys.load()).thenAnswer((_) async => surveys);
  });

  test('Should call loadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load());
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingController, emitsInOrder([true, false]));

    sut.surveysStream.listen(expectAsync1((surveyEntity) => expect(
        surveyEntity,
        equals(
          [
            SurveyViewModel(
              id: surveys.first.id,
              question: surveys.first.question,
              date: '20 Feb 2020',
              didAnswer: surveys.first.didAnswer,
            ),
            SurveyViewModel(
              id: surveys.last.id,
              question: surveys.last.question,
              date: '03 Oct 2018',
              didAnswer: surveys.last.didAnswer,
            )
          ],
        ))));

    await sut.loadData();
  });

  test('Should emit correct events on failure', () async {
    when(loadSurveys.load()).thenThrow(DomainError.unexpected);

    expectLater(sut.isLoadingController, emitsInOrder([true, false]));

    sut.surveysStream.listen(
      null,
      onError: expectAsync1(
        (error) => expect(error, UIError.unexpected.description),
      ),
    );

    sut.loadData();
  });

  test('Should go to SurveyResultPage on surveyItem click', () async {
    sut.navigateToStream.listen(
        expectAsync1((page) => expect(page, equals('/survey_result/1'))));

    sut.goToSurveyResult('1');
  });

  test('Should logout if accessDeniedError', () async {
    when(loadSurveys.load()).thenThrow(DomainError.accessDenied);

    expectLater(sut.isLoadingController, emitsInOrder([true, false]));

    expectLater(sut.isSessionExpiredStream, emits(true));

    sut.loadData();
  });
}
