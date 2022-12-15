import 'survey_result_view_model.dart';

abstract class SurveyResultPresenter {
  Stream<SurveyResultViewModel> get surveyResultController;
  Stream<bool> get isLoadingController;
  Future<void> loadData();
}
