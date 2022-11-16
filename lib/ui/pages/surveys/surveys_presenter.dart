abstract class SurveysPresenter {
  Stream<bool> get isLoadingController;

  Future<void> loadData();
}
