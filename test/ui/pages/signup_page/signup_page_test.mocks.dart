// Mocks generated by Mockito 5.3.1 from annotations
// in fordev/test/ui/pages/signup_page/signup_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:fordev/ui/helpers/helpers.dart' as _i4;
import 'package:fordev/ui/pages/signup/signup_presenter.dart' as _i2;
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

/// A class which mocks [SignUpPresenter].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignUpPresenter extends _i1.Mock implements _i2.SignUpPresenter {
  MockSignUpPresenter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<_i4.UIError?> get nameErrorController => (super.noSuchMethod(
        Invocation.getter(#nameErrorController),
        returnValue: _i3.Stream<_i4.UIError?>.empty(),
      ) as _i3.Stream<_i4.UIError?>);
  @override
  _i3.Stream<_i4.UIError?> get emailErrorController => (super.noSuchMethod(
        Invocation.getter(#emailErrorController),
        returnValue: _i3.Stream<_i4.UIError?>.empty(),
      ) as _i3.Stream<_i4.UIError?>);
  @override
  _i3.Stream<_i4.UIError?> get passwordErrorController => (super.noSuchMethod(
        Invocation.getter(#passwordErrorController),
        returnValue: _i3.Stream<_i4.UIError?>.empty(),
      ) as _i3.Stream<_i4.UIError?>);
  @override
  _i3.Stream<_i4.UIError?> get passwordConfirmationErrorController =>
      (super.noSuchMethod(
        Invocation.getter(#passwordConfirmationErrorController),
        returnValue: _i3.Stream<_i4.UIError?>.empty(),
      ) as _i3.Stream<_i4.UIError?>);
  @override
  _i3.Stream<_i4.UIError?> get mainErrorStreamController => (super.noSuchMethod(
        Invocation.getter(#mainErrorStreamController),
        returnValue: _i3.Stream<_i4.UIError?>.empty(),
      ) as _i3.Stream<_i4.UIError?>);
  @override
  _i3.Stream<bool> get isFormValidController => (super.noSuchMethod(
        Invocation.getter(#isFormValidController),
        returnValue: _i3.Stream<bool>.empty(),
      ) as _i3.Stream<bool>);
  @override
  _i3.Stream<bool> get isLoadingController => (super.noSuchMethod(
        Invocation.getter(#isLoadingController),
        returnValue: _i3.Stream<bool>.empty(),
      ) as _i3.Stream<bool>);
  @override
  _i3.Stream<String?> get navigateToController => (super.noSuchMethod(
        Invocation.getter(#navigateToController),
        returnValue: _i3.Stream<String?>.empty(),
      ) as _i3.Stream<String?>);
  @override
  void validateName(String? name) => super.noSuchMethod(
        Invocation.method(
          #validateName,
          [name],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void validateEmail(String? email) => super.noSuchMethod(
        Invocation.method(
          #validateEmail,
          [email],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void validatePassword(String? password) => super.noSuchMethod(
        Invocation.method(
          #validatePassword,
          [password],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void validatePasswordConfirmation(String? password) => super.noSuchMethod(
        Invocation.method(
          #validatePasswordConfirmation,
          [password],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.Future<void> signUp() => (super.noSuchMethod(
        Invocation.method(
          #signUp,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
