import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/usecases/usecases.dart';

import 'remote_load_surveys_with_local_fallback_test.mocks.dart';

class RemoteLoadSurveysWithLocalFallback {
  final RemoteLoadSurveys _remote;

  RemoteLoadSurveysWithLocalFallback({required RemoteLoadSurveys remote})
      : _remote = remote;

  Future load() async {
    await _remote.load();
  }
}

@GenerateMocks([RemoteLoadSurveys])
main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late MockRemoteLoadSurveys remote;

  setUp(() {
    remote = MockRemoteLoadSurveys();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote);
  });

  test('Should call remote load', () async {
    when(remote.load()).thenAnswer((_) async => []);

    await sut.load();

    verify(remote.load()).called(1);
  });
}
