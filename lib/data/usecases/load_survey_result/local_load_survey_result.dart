import 'package:fordev/data/models/local_survey_result_model.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import '../../../domain/entities/entities.dart';
import '../../cache/cache.dart';

class LocalLoadSurveyResult {
  final CacheStorage _cacheStorage;

  LocalLoadSurveyResult({required CacheStorage cacheStorage})
      : _cacheStorage = cacheStorage;

  Future<SurveyResultEntity> loadBySurvey({String? surveyId}) async {
    try {
      final result = await _cacheStorage.fetch('survey_result/$surveyId');

      if (result?.isEmpty != false) {
        throw Exception();
      }
      return LocalSurveyResultModel.fromMap(result).toEntity();
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String? surveyId) async {
    try {
      final response = await _cacheStorage.fetch('survey_result/$surveyId');
      LocalSurveyResultModel.fromMap(response).toEntity();
    } catch (e) {
      await _cacheStorage.delete('survey_result/$surveyId');
    }
  }

  Future<void> save({
    required String surveyId,
    required SurveyResultEntity survey,
  }) async {
    try {
      await _cacheStorage.save(
        key: 'survey_result/$surveyId',
        value: LocalSurveyResultModel.fromEntity(survey).toMap(),
      );
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
