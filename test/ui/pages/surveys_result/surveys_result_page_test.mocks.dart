// Mocks generated by Mockito 5.3.2 from annotations
// in fordev/test/ui/pages/surveys_result/surveys_result_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:fordev/ui/pages/survey_result/survey_result_presenter.dart'
    as _i2;
import 'package:fordev/ui/pages/survey_result/survey_result_view_model.dart'
    as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [SurveyResultPresenter].
///
/// See the documentation for Mockito's code generation for more information.
class MockSurveyResultPresenter extends _i1.Mock
    implements _i2.SurveyResultPresenter {
  MockSurveyResultPresenter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<_i4.SurveyResultViewModel> get surveyResultController =>
      (super.noSuchMethod(
        Invocation.getter(#surveyResultController),
        returnValue: _i3.Stream<_i4.SurveyResultViewModel>.empty(),
      ) as _i3.Stream<_i4.SurveyResultViewModel>);
  @override
  _i3.Stream<bool> get isLoadingController => (super.noSuchMethod(
        Invocation.getter(#isLoadingController),
        returnValue: _i3.Stream<bool>.empty(),
      ) as _i3.Stream<bool>);
  @override
  _i3.Stream<bool?> get isSessionExpiredStream => (super.noSuchMethod(
        Invocation.getter(#isSessionExpiredStream),
        returnValue: _i3.Stream<bool?>.empty(),
      ) as _i3.Stream<bool?>);
  @override
  _i3.Future<void> loadData() => (super.noSuchMethod(
        Invocation.method(
          #loadData,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> save({required String? answer}) => (super.noSuchMethod(
        Invocation.method(
          #save,
          [],
          {#answer: answer},
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
