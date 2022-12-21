import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';

class RemoteLoadSurveyResultWithLocalFallback {
  final RemoteLoadSurveyResult _remoteLoadSurveyResult;
  final LocalLoadSurveyResult _localLoadSurveyResult;

  RemoteLoadSurveyResultWithLocalFallback({
    required RemoteLoadSurveyResult remoteLoadSurveyResult,
    required LocalLoadSurveyResult localLoadSurveyResult,
  })  : _remoteLoadSurveyResult = remoteLoadSurveyResult,
        _localLoadSurveyResult = localLoadSurveyResult;

  Future<SurveyResultEntity> loadBySurvey({String? surveyId}) async {
    try {
      final data = await _remoteLoadSurveyResult.loadBySurvey(
        surveyId: surveyId,
      );
      await _localLoadSurveyResult.save(surveyId: surveyId!, survey: data);
      return data;
    } catch (e) {
      if (e == DomainError.accessDenied) {
        rethrow;
      } else {
        await _localLoadSurveyResult.validate(surveyId);
        return await _localLoadSurveyResult.loadBySurvey(surveyId: surveyId);
      }
    }
  }
}
