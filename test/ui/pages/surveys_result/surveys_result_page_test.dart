import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'surveys_result_page_test.mocks.dart';

@GenerateMocks([SurveyResultPresenter])
void main() {
  late MockSurveyResultPresenter presenter;
  late StreamController<bool> isLoadingController;

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

    when(presenter.isLoadingController)
        .thenAnswer((_) => isLoadingController.stream);
  });

  tearDown(() {
    isLoadingController.close();
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
}
