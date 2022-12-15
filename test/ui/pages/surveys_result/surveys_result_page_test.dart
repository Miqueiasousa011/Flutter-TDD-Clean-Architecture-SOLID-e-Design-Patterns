import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/utils/i18n/i18n.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'surveys_result_page_test.mocks.dart';

@GenerateMocks([SurveyResultPresenter])
void main() {
  late MockSurveyResultPresenter presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<List> surveyResultController;

  Future<void> loadPage(WidgetTester tester) async {
    final page = GetMaterialApp(
      initialRoute: '/surveys_result/1',
      getPages: [
        GetPage(
          name: '/surveys_result/:survey_id',
          page: () => SurveyResultPage(presenter: presenter),
        )
      ],
    );

    await tester.pumpWidget(page);
  }

  setUp(() {
    presenter = MockSurveyResultPresenter();
    isLoadingController = StreamController();
    surveyResultController = StreamController();

    when(presenter.isLoadingController)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.surveyResultController)
        .thenAnswer((_) => surveyResultController.stream);
  });

  tearDown(() {
    isLoadingController.close();
    surveyResultController.close();
  });

  testWidgets('Should call LoadSurveysResult on page load', (tester) async {
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

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text(R.strings.msgUnexpectedError), findsOneWidget);
    expect(find.text(R.strings.reload), findsOneWidget);
  });

  // testWidgets('Should present list if loadSurveysStream success',
  //     (tester) async {
  //   await loadPage(tester);

  //   surveyResultController.add([]);

  //   await tester.pump();

  //   expect(find.byType(ListView), findsOneWidget);
  //   expect(find.text('Enquete 1'), findsOneWidget);
  //   expect(find.text('React'), findsOneWidget);
  //   expect(find.text(R.strings.reload), findsNothing);
  // });

  testWidgets('Should call LoadSurveys on click reload button', (tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected);

    await tester.pump();

    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);

    verify(presenter.loadData()).called(2);
  });
}
