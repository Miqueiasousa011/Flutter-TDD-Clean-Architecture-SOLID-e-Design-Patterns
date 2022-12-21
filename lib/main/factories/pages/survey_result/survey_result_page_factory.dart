import 'package:flutter/material.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/main/factories/http/api_url_factory.dart';
import 'package:fordev/main/factories/http/http_factory.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';

import '../../../../infra/cache/cache.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../../composites/composites.dart';

Widget makeSurveyResultPage() {
  return SurveyResultPage(presenter: makeGetxSurveyResultPresenter());
}

SurveyResultPresenter makeGetxSurveyResultPresenter() {
  final surveyId = Get.parameters['survey_id'] ?? '';
  return GetxSurveyResultPresenter(
    loadSurveyResult: makeRemoteLoadSurveyResult(surveyId),
    surveyId: surveyId,
  );
}

makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResultWithLocalFallback(
    remoteLoadSurveyResult: RemoteLoadSurveyResult(
      url: makeApiUrl('/surveys/$surveyId/results'),
      client: makeHttpAdapter(),
    ),
    localLoadSurveyResult: LocalLoadSurveyResult(
      cacheStorage: LocalStorageAdapter(
        localStorage: LocalStorage('forDev'),
      ),
    ),
  );
}
