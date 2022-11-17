import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/utils/i18n/i18n.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/pages.dart';

import 'survey_page_test.mocks.dart';

@GenerateMocks([SurveysPresenter])
void main() {
  late MockSurveysPresenter presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<List<SurveyViewModel>> surveysStream;

  setUp(() {
    presenter = MockSurveysPresenter();

    isLoadingController = StreamController();
    when(presenter.isLoadingController)
        .thenAnswer((_) => isLoadingController.stream);

    surveysStream = StreamController();
    when(presenter.surveysStream).thenAnswer((_) => surveysStream.stream);
  });

  tearDown(() {
    isLoadingController.close();
    surveysStream.close();
  });

  List<SurveyViewModel> makeSurveys() {
    return [
      SurveyViewModel(
        id: '1',
        question: 'question 1',
        date: 'date 1',
        didAnswer: faker.randomGenerator.boolean(),
      ),
      SurveyViewModel(
        id: '2',
        question: 'question 2',
        date: 'date 2',
        didAnswer: faker.randomGenerator.boolean(),
      ),
    ];
  }

  Future<void> loadPage(WidgetTester tester) async {
    final page = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveyPage(presenter: presenter))
      ],
    );

    await tester.pumpWidget(page);
  }

  testWidgets('Should call LoadSurveys on page load', (tester) async {
    await loadPage(tester);

    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should handle loading correctly', (tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error if loadSurveysStream fails',
      (tester) async {
    await loadPage(tester);

    surveysStream.addError(UIError.unexpected.description);

    await tester.pump();

    expect(find.text(R.strings.msgUnexpectedError), findsOneWidget);
    expect(find.text(R.strings.reload), findsOneWidget);
  });

  testWidgets('Should present list if loadSurveysStream success',
      (tester) async {
    await loadPage(tester);

    surveysStream.add(makeSurveys());

    await tester.pump();

    expect(find.text('question 1'), findsWidgets);
    expect(find.text('question 2'), findsWidgets);
    expect(find.text('date 1'), findsWidgets);
    expect(find.text('date 2'), findsWidgets);
    expect(find.text(R.strings.msgUnexpectedError), findsNothing);
    expect(find.text(R.strings.reload), findsNothing);
  });

  testWidgets('Should call LoadSurveys on click reload button', (tester) async {
    await loadPage(tester);

    //Adicionado erro na tela
    surveysStream.addError(UIError.unexpected.description);

    await tester.pump();

    //Com o erro o botão de reload deve ficar visivel
    await tester.ensureVisible(find.byType(ElevatedButton));
    //Clicando no botão
    await tester.tap(find.byType(ElevatedButton));
    //o segundo reload deve acontecer.
    verify(presenter.loadData()).called(2);
  });
}
