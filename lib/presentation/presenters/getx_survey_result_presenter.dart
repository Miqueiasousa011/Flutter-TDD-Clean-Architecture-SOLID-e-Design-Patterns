import 'dart:async';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxSurveyResultPresenter {
  final LoadSurveyResultUsecase _loadSurveyResult;
  final String _surveyId;

  GetxSurveyResultPresenter({
    required LoadSurveyResultUsecase loadSurveyResult,
    required String surveyId,
  })  : _loadSurveyResult = loadSurveyResult,
        _surveyId = surveyId;

  final _isLoading = RxBool(false);
  final _controller = StreamController<SurveyResultViewModel>();

  Stream<bool> get isLoadingController => _isLoading.stream;

  Stream<SurveyResultViewModel> get surveyResultController =>
      _controller.stream;

  Future<void> loadData() async {
    _isLoading.value = true;

    try {
      final surveyResultEntity = await _loadSurveyResult.loadBySurvey(
        surveyId: _surveyId,
      );

      _controller.sink.add(
        SurveyResultViewModel(
          surveyId: surveyResultEntity.surveyId,
          question: surveyResultEntity.question,
          answers: surveyResultEntity.answers
              .map(
                (e) => SurveyAnswerViewModel(
                  image: e.image ?? '',
                  answer: e.answer,
                  isCurrentAnswer: e.isCurrentAnswer,
                  percent: '${e.percent}%',
                ),
              )
              .toList(),
        ),
      );
    } catch (e) {
      _controller.addError(DomainError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }
}
