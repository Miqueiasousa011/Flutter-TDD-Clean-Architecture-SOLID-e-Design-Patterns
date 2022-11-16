import 'survey_viewmodel.dart';

abstract class SurveysPresenter {
  Stream<bool> get isLoadingController;
  Stream<List<SurveyViewModel>> get loadSurveysController;

  Future<void> loadData();
}
