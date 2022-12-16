import 'package:flutter/material.dart';
import 'package:fordev/data/cache/delete_secure_cache_storage.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/main/composites/composites.dart';
import 'package:fordev/main/decorators/authorize_http_client_decorator.dart';
import 'package:fordev/main/factories/cache/cache.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../../http/http.dart';

Widget makeSurveyPage() {
  return SurveyPage(presenter: makeGetxSurveysPresenter());
}

SurveysPresenter makeGetxSurveysPresenter() {
  return GetxSurveysPresenter(
    loadSurveys: makeRemoteLoadSurveysWithLocalFallback(),
  );
}

RemoteLoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    client: AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: makeSecureStorageAdapter(),
      deleteSecureCacheStorage: A(),
      decoratee: makeHttpAdapter(),
    ),
    url: makeApiUrl('surveys'),
  );
}

LocalLoadSurveys makeLocalLoadSurveys() {
  return LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());
}

RemoteLoadSurveysWithLocalFallback makeRemoteLoadSurveysWithLocalFallback() {
  return RemoteLoadSurveysWithLocalFallback(
    remote: makeRemoteLoadSurveys(),
    local: makeLocalLoadSurveys(),
  );
}

class A implements DeleteSecureCacheStorage {
  @override
  Future<void> delete(String key) async {}
}
