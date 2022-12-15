abstract class SurveyResultPresenter {
  Stream<List> get surveyResultController;
  Stream<bool> get isLoadingController;
  Future<void> loadData();
}
