import 'dart:async';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/presentation/mixins/mixins.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../helpers/helpers.dart';

import 'package:get/get.dart';

class GetxSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager
    implements SurveyResultPresenter {
  final LoadSurveyResultUsecase _loadSurveyResult;
  final SaveSurveyResultUsecase _saveSurveyResult;
  final String _surveyId;

  GetxSurveyResultPresenter({
    required LoadSurveyResultUsecase loadSurveyResult,
    required SaveSurveyResultUsecase saveSurveyResult,
    required String surveyId,
  })  : _loadSurveyResult = loadSurveyResult,
        _saveSurveyResult = saveSurveyResult,
        _surveyId = surveyId;

  final _controller = StreamController<SurveyResultViewModel>();

  @override
  Stream<SurveyResultViewModel> get surveyResultController =>
      _controller.stream;

  @override
  Future<void> loadData() async {
    await showResultOnAction(
        () => _loadSurveyResult.loadBySurvey(surveyId: _surveyId));
  }

  @override
  Future<void> save({required String answer}) async {
    await showResultOnAction(() => _saveSurveyResult.save(answer: answer));
  }

  //Trecho de código se repetia nos 2 métodos acima, então aplicamos o DRY
  Future<void> showResultOnAction(
    Future<SurveyResultEntity> Function() action,
  ) async {
    try {
      isLoading = true;
      final result = await action();
      _controller.sink.add(result.toViewModel());
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
}
