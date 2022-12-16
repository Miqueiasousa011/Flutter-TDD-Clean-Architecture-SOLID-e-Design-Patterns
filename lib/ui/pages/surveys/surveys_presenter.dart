import 'survey_viewmodel.dart';

abstract class SurveysPresenter {
  Stream<bool> get isLoadingController;
  Stream<List<SurveyViewModel>> get surveysStream;
  Stream<String?> get navigateToStream;
  Stream<bool?> get isSessionExpiredStream;

  Future<void> loadData();
  void goToSurveyResult(String surveyId);
}
