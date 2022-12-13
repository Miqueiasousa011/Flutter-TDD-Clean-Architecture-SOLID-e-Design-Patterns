import '../entities/survey_result_entity.dart';

abstract class LoadSurveyResultUsecase {
  Future<SurveyResultEntity> loadBySurvey({String? surveyId});
}
