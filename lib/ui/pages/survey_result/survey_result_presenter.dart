import 'survey_result_view_model.dart';

abstract class SurveyResultPresenter {
  Stream<SurveyResultViewModel> get surveyResultController;
  Stream<bool> get isLoadingController;
  Stream<bool?> get isSessionExpiredStream;
  Future<void> loadData();
  Future<void> save({required String answer});
}
