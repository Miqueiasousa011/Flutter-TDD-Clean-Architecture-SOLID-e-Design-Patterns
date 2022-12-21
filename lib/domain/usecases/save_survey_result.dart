import '../entities/entities.dart';

abstract class SaveSurveyResultUsecase {
  Future<SurveyResultEntity> save({required String answer});
}
