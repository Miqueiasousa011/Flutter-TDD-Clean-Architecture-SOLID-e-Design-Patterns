import 'survey_viewmodel.dart';

abstract class SurveysPresenter {
  Stream<bool> get isLoadingController;
  Stream<List<SurveyViewModel>> get surveysStream;

  Future<void> loadData();
  void goToSurveyResult(String surveyId);
  Stream<String?> get navigateToStream;
}
