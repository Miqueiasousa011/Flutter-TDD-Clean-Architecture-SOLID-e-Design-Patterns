import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveyResult {
  final String _url;
  final HttpClient _client;

  RemoteLoadSurveyResult({
    required String url,
    required HttpClient client,
  })  : _client = client,
        _url = url;

  Future<SurveyResultEntity> loadBySurvey() async {
    try {
      final response = await _client.request(url: _url, method: 'get');
      return RemoteSurveyResultModel.fromJson(response).toEntity();
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
