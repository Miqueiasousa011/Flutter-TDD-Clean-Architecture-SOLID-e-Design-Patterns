import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveys implements LoadSurveysUsecase {
  final CacheStorage _cacheStorage;

  LocalLoadSurveys({required CacheStorage cacheStorage})
      : _cacheStorage = cacheStorage;

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final response = await _cacheStorage.fetch('surveys');

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

  Future<void> validate() async {
    final response = await _cacheStorage.fetch('surveys');

    try {
      response.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json));
    } catch (e) {
      await _cacheStorage.delete('surveys');
    }
  }
}
