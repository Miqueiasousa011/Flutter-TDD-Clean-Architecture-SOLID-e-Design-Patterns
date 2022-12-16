import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/utils/i18n/i18n.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'surveys_result_page_test.mocks.dart';

@GenerateMocks([SurveyResultPresenter])
void main() {
  late MockSurveyResultPresenter presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<SurveyResultViewModel> surveyResultController;
  late StreamController<bool?> isSessionExpiredController;

  Future<void> loadPage(WidgetTester tester) async {
    final page = GetMaterialApp(
      initialRoute: '/surveys_result/1',
      getPages: [
        GetPage(
          name: '/surveys_result/:survey_id',
          page: () => SurveyResultPage(presenter: presenter),
        ),
        GetPage(
          name: '/login',
          page: () => Container(),
        ),
      ],
    );
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(page);
    });
  }

  SurveyResultViewModel mockSurveyResult() {
    return SurveyResultViewModel(
      surveyId: faker.guid.guid(),
      question: faker.randomGenerator.string(40),
      answers: const [
        SurveyAnswerViewModel(
          image: 'image 1',
          answer: 'React',
          isCurrentAnswer: false,
          percent: '100%',
        ),
        SurveyAnswerViewModel(
          image: '',
          answer: 'Flutter',
          isCurrentAnswer: true,
          percent: '10%',
        ),
      ],
    );
  }

  setUp(() {
    presenter = MockSurveyResultPresenter();
    isLoadingController = StreamController();
    surveyResultController = StreamController();
    isSessionExpiredController = StreamController();

    when(presenter.isLoadingController)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.surveyResultController)
        .thenAnswer((_) => surveyResultController.stream);

    when(presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  });

  tearDown(() {
    isLoadingController.close();
    surveyResultController.close();
    isSessionExpiredController.close();
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

  testWidgets('Should call LoadSurveys on click reload button', (tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected);

    await tester.pump();

    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);

    verify(presenter.loadData()).called(2);
  });

  testWidgets('Should present SurveysStream success', (tester) async {
    await loadPage(tester);

    surveyResultController.add(mockSurveyResult());

    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('React'), findsOneWidget);
    expect(find.text(R.strings.reload), findsNothing);

    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisabledIcon), findsOneWidget);

    final image =
        tester.widget<Image>(find.byType(Image)).image as NetworkImage;

    expect(image.url, equals('image 1'));
  });

  testWidgets('Should logout', (tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(true);
    await tester.pumpAndSettle();

    expect(Get.currentRoute, equals('/login'));
  });

  testWidgets('Should not logout', (tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(false);
    await tester.pumpAndSettle();

    expect(Get.currentRoute, equals('/surveys_result/1'));

    isSessionExpiredController.add(null);
    await tester.pumpAndSettle();

    expect(Get.currentRoute, equals('/surveys_result/1'));
  });
}
