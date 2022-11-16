import 'package:fordev/domain/usecases/load_surveys_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'getx_presentation_test.mocks.dart';

class GetxSurveysPresenter {
  final LoadSurveysUsecase _loadSurveys;

  GetxSurveysPresenter({required LoadSurveysUsecase loadSurveys})
      : _loadSurveys = loadSurveys;

  Future<void> loadData() async {
    await _loadSurveys.load();
  }
}

@GenerateMocks([LoadSurveysUsecase])
void main() {
  late GetxSurveysPresenter sut;
  late MockLoadSurveysUsecase loadSurveys;

  setUp(() {
    loadSurveys = MockLoadSurveysUsecase();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
  });

  test('Should call loadSurveys on loadData', () async {
    when(loadSurveys.load()).thenAnswer((_) async => []);

    await sut.loadData();

    verify(loadSurveys.load());
  });
}
