import 'dart:async';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSurveysPresenter
    with SessionManager, LoadingManager
    implements SurveysPresenter {
  final LoadSurveysUsecase _loadSurveys;

  GetxSurveysPresenter({required LoadSurveysUsecase loadSurveys})
      : _loadSurveys = loadSurveys;

  final _controller = StreamController<List<SurveyViewModel>>();

  @override
  Stream<List<SurveyViewModel>> get surveysStream => _controller.stream;

  final _navigateTo = Rx<String?>(null);

  @override
  Future<void> loadData() async {
    try {
      isLoading = true;
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
        isSessionExpired = true;
      } else {
        _controller.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToSurveyResult(String surveyId) {
    _navigateTo.value = '/survey_result/$surveyId';
  }

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;
}
