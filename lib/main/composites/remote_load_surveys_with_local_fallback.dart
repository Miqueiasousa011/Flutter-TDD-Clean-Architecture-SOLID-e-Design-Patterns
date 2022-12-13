import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveysUsecase {
  final RemoteLoadSurveys _remote;
  final LocalLoadSurveys _local;

  RemoteLoadSurveysWithLocalFallback(
      {required RemoteLoadSurveys remote, required LocalLoadSurveys local})
      : _remote = remote,
        _local = local;

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final surveys = await _remote.load();
      await _local.save(surveys);

      return surveys;
    } catch (e) {
      if (e == DomainError.accessDenied) {
        rethrow;
      }
      await _local.validate();
      return await _local.load();
    }
  }
}
