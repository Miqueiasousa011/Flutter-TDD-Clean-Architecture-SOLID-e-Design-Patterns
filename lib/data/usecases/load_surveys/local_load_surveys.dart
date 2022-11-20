import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveys implements LoadSurveysUsecase {
  final FetchCacheStorage _fetchCacheStorage;

  LocalLoadSurveys({required FetchCacheStorage fetchCacheStorage})
      : _fetchCacheStorage = fetchCacheStorage;

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final response = await _fetchCacheStorage.fetch('surveys');

      if (response?.isEmpty != false) {
        throw Exception();
      }

      return response
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
