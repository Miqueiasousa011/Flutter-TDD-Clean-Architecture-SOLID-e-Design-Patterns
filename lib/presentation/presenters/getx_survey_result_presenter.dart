import 'dart:async';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/presentation/mixins/mixins.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import 'package:get/get.dart';

class GetxSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager
    implements SurveyResultPresenter {
  final LoadSurveyResultUsecase _loadSurveyResult;
  final String _surveyId;

  GetxSurveyResultPresenter({
    required LoadSurveyResultUsecase loadSurveyResult,
    required String surveyId,
  })  : _loadSurveyResult = loadSurveyResult,
        _surveyId = surveyId;

  final _controller = StreamController<SurveyResultViewModel>();

  @override
  Stream<SurveyResultViewModel> get surveyResultController =>
      _controller.stream;

  @override
  Future<void> loadData() async {
    isLoading = true;

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
    } on DomainError catch (e) {
      if (e == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _controller.addError(DomainError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> save({required String answer}) {
    throw UnimplementedError();
  }
}
