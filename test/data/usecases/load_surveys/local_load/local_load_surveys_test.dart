import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'local_load_surveys_test.mocks.dart';

class LocalLoadSurveys {
  final FetchCacheStorage _fetchCacheStorage;

  LocalLoadSurveys({required FetchCacheStorage fetchCacheStorage})
      : _fetchCacheStorage = fetchCacheStorage;

  Future load() async {
    await _fetchCacheStorage.fetch('surveys');
  }
}

abstract class FetchCacheStorage {
  Future fetch(String key);
}

@GenerateMocks([FetchCacheStorage])
void main() {
  late MockFetchCacheStorage fetchCacheStorage;
  late LocalLoadSurveys sut;

  setUp(() {
    fetchCacheStorage = MockFetchCacheStorage();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
  });

  test('Should call FetchCacheStorage with correct key', () async {
    when(fetchCacheStorage.fetch('surveys')).thenAnswer((_) async => 'any');

    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });
}
