import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/pages.dart';

import 'survey_page_test.mocks.dart';

@GenerateMocks([SurveysPresenter])
void main() {
  late MockSurveysPresenter presenter;

  setUp(() {
    presenter = MockSurveysPresenter();
  });

  testWidgets('Should call LoadSurveys on page load', (tester) async {
    final page = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveyPage(presenter: presenter))
      ],
    );

    await tester.pumpWidget(page);

    verify(presenter.loadData()).called(1);
  });
}
