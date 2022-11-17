import 'package:flutter/material.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/main/decorators/authorize_http_client_decorator.dart';
import 'package:fordev/main/factories/cache/cache.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../../http/http.dart';

Widget makeSurveyPage() {
  return SurveyPage(presenter: makeGetxSurveysPresenter());
}

SurveysPresenter makeGetxSurveysPresenter() {
  return GetxSurveysPresenter(loadSurveys: makeRemoteLoadSurveys());
}

LoadSurveysUsecase makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    client: AuthorizeHttpClientDecorator(
      secureCacheStorage: makeLocalStorageAdapter(),
      decoratee: makeHttpAdapter(),
    ),
    url: makeApiUrl('surveys'),
  );
}
