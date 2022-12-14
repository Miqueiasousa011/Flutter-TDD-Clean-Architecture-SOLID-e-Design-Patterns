import 'package:fordev/domain/usecases/usecases.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveyResult implements LoadSurveyResultUsecase {
  final String _url;
  final HttpClient _client;

  RemoteLoadSurveyResult({
    required String url,
    required HttpClient client,
  })  : _client = client,
        _url = url;

  @override
  Future<SurveyResultEntity> loadBySurvey({String? surveyId}) async {
    try {
      final response = await _client.request(url: _url, method: 'get');
      return RemoteSurveyResultModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbiddenError
          ? DomainError.accessDenied
          : throw DomainError.unexpected;
    }
  }
}
