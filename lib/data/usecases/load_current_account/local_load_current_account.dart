import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccountUsecase {
  final FetchSecureCacheStorage _fetchSecure;

  LocalLoadCurrentAccount({
    required FetchSecureCacheStorage fetchSecure,
  }) : _fetchSecure = fetchSecure;

  @override
  Future<AccountEntity> load() async {
    try {
      final token = await _fetchSecure.fetchSecure('token');
      return AccountEntity(token: token);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
