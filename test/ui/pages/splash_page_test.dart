import 'dart:async';

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
    return Scaffold(body: Builder(
      builder: (context) {
        presenter.navigateToStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page!);
          }
        });

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}

abstract class SplashPresenter {
  Stream<String?> get navigateToStream;
  Future<void> loadCurrentAccount();
}

@GenerateMocks([SplashPresenter])
void main() {
  late MockSplashPresenter presenter;
  late StreamController<String?> navigateToController;

  Future<void> loadPage(tester) async {
    presenter = MockSplashPresenter();

    navigateToController = StreamController<String?>();
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);

    final splashPage = GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashPage(presenter: presenter)),
        GetPage(
          name: '/any_route',
          page: () => const Scaffold(body: Text('any_route')),
        )
      ],
    );

    await tester.pumpWidget(splashPage);
  }

  tearDown(() {
    navigateToController.close();
  });

  testWidgets('Should present spinner on page load', (tester) async {
    await loadPage(tester);

    expect(Get.currentRoute, equals('/'));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call loadCurrentAccount on page load', (tester) async {
    await loadPage(tester);

    verify(presenter.loadCurrentAccount()).called(1);
  });

  testWidgets('Should navigate to homePage', (tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');

    await tester.pumpAndSettle();

    expect(Get.currentRoute, equals('/any_route'));
    expect(find.text('any_route'), findsOneWidget);
  });

  testWidgets('Should not navigate', (tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, equals('/'));

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, equals('/'));
  });
}
