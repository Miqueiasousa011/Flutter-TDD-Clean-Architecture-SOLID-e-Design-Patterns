import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'splash_page_test.mocks.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key, required this.presenter});

  final SplashPresenter presenter;

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

abstract class SplashPresenter {
  Future<void> loadCurrentAccount();
}

@GenerateMocks([SplashPresenter])
void main() {
  late MockSplashPresenter presenter;

  Future<void> loadPage(tester) async {
    presenter = MockSplashPresenter();

    final splashPage = GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashPage(presenter: presenter))
      ],
    );

    await tester.pumpWidget(splashPage);
  }

  testWidgets('Should present spinner on page load', (tester) async {
    await loadPage(tester);

    expect(Get.currentRoute, equals('/'));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call loadCurrentAccount on page load', (tester) async {
    await loadPage(tester);

    verify(presenter.loadCurrentAccount()).called(1);
  });
}
