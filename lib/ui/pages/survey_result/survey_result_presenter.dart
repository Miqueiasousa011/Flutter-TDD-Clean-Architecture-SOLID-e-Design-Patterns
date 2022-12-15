abstract class SurveyResultPresenter {
  Stream<bool> get isLoadingController;
  Future<void> loadData();
}
