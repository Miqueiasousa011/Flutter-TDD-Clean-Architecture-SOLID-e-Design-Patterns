import 'dart:async';

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
  late StreamController<List<SurveyViewModel>> loadSurveysController;

  setUp(() {
    presenter = MockSurveysPresenter();

    isLoadingController = StreamController();
    when(presenter.isLoadingController)
        .thenAnswer((_) => isLoadingController.stream);

    loadSurveysController = StreamController();
    when(presenter.loadSurveysController)
        .thenAnswer((_) => loadSurveysController.stream);
  });

  tearDown(() {
    isLoadingController.close();
    loadSurveysController.close();
  });

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

    loadSurveysController.addError(UIError.unexpected.description);

    await tester.pump();

    expect(find.text(R.strings.msgUnexpectedError), findsOneWidget);
    expect(find.text(R.strings.reload), findsOneWidget);
  });
}
