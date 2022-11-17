import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter {
  final LoadSurveysUsecase _loadSurveys;

  GetxSurveysPresenter({required LoadSurveysUsecase loadSurveys})
      : _loadSurveys = loadSurveys;

  final _isLoading = RxBool(false);
  final _surveys = Rx<List<SurveyViewModel>>([]);

  Stream<bool> get isLoadingController => _isLoading.stream;

  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final surveys = await _loadSurveys.load();

      _surveys.value = surveys
          .map((entity) => SurveyViewModel(
                id: entity.id,
                question: entity.question,
                date: DateFormat(
                  'dd MMM yyyy',
                ).format(entity.dateTime),
                didAnswer: entity.didAnswer,
              ))
          .toList();
    } on DomainError {
      _surveys.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }
}
