import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveys implements LoadSurveysUsecase {
  final HttpClient _client;
  final String _url;

  RemoteLoadSurveys({
    required HttpClient client,
    required String url,
  })  : _client = client,
        _url = url;

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final response = await _client.request(url: _url, method: 'get');
      List<SurveyEntity> surveys = [
        ...response.map((json) => RemoteSurveyModel.fromJson(json).toEntity())
      ];
      return surveys;
    } on HttpError catch (error) {
      throw error == HttpError.forbiddenError
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
