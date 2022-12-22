import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteSaveSurveyResult implements SaveSurveyResultUsecase {
  final HttpClient _httpClient;
  final String _url;

  RemoteSaveSurveyResult({
    required HttpClient httpClient,
    required String url,
  })  : _httpClient = httpClient,
        _url = url;

  @override
  Future<SurveyResultEntity> save({required String answer}) async {
    try {
      final response = await _httpClient.request(
        url: _url,
        method: 'put',
        body: {'answer': answer},
      );
      return RemoteSurveyResultModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbiddenError
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
