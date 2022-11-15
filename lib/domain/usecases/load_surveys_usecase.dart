import '../entities/entities.dart';

abstract class LoadSurveysUsecase {
  Future<List<SurveyEntity>> load();
}
