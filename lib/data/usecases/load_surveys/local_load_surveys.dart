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

      return _jsonToEntyity(response);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final response = await _cacheStorage.fetch('surveys');

      _jsonToEntyity(response);
    } catch (e) {
      await _cacheStorage.delete('surveys');
    }
  }

  Future<void> save(List<SurveyEntity> surveys) async {
    await _cacheStorage.save(key: 'surveys', value: _entityToJson(surveys));
  }

  List<SurveyEntity> _jsonToEntyity(List<Map<String, dynamic>> listOfJson) =>
      listOfJson
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();

  List<Map<String, dynamic>> _entityToJson(List<SurveyEntity> list) => list
      .map((entity) => LocalSurveyModel.fromEntity(entity).toMap())
      .toList();
}
