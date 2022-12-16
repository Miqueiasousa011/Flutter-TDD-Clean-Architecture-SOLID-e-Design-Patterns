import 'dart:async';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter implements SurveysPresenter {
  final LoadSurveysUsecase _loadSurveys;

  GetxSurveysPresenter({required LoadSurveysUsecase loadSurveys})
      : _loadSurveys = loadSurveys;

  final _isLoading = RxBool(false);

  //var _surveys = Rx<List<SurveyViewModel>>([]);

  final _controller = StreamController<List<SurveyViewModel>>();

  @override
  Stream<bool> get isLoadingController => _isLoading.stream;

  @override
  Stream<List<SurveyViewModel>> get surveysStream => _controller.stream;

  final _navigateTo = Rx<String?>(null);
  final _isSessionExpired = Rx<bool?>(null);

  @override
  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final surveys = await _loadSurveys.load();
      final value = surveys
          .map(
            (survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.dateTime),
              didAnswer: survey.didAnswer,
            ),
          )
          .toList();

      _controller.add(value);
    } on DomainError catch (e) {
      if (e == DomainError.accessDenied) {
        _isSessionExpired.value = true;
      } else {
        _controller.addError(UIError.unexpected.description);
      }
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void goToSurveyResult(String surveyId) {
    _navigateTo.value = '/survey_result/$surveyId';
  }

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  @override
  Stream<bool?> get isSessionExpiredStream => _isSessionExpired.stream;
}
