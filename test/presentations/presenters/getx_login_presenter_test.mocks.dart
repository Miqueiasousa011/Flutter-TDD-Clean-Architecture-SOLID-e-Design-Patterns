// Mocks generated by Mockito 5.3.2 from annotations
// in fordev/test/presentations/presenters/getx_login_presenter_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:fordev/domain/entities/entities.dart' as _i2;
import 'package:fordev/domain/usecases/authentication_usecase.dart' as _i4;
import 'package:fordev/domain/usecases/save_current_account_usecase.dart'
    as _i6;
import 'package:fordev/presentation/protocols/validation.dart' as _i3;
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

class _FakeAccountEntity_0 extends _i1.SmartFake implements _i2.AccountEntity {
  _FakeAccountEntity_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Validation].
///
/// See the documentation for Mockito's code generation for more information.
class MockValidation extends _i1.Mock implements _i3.Validation {
  MockValidation() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.ValidationError? validate({
    required String? field,
    required Map<String, dynamic>? input,
  }) =>
      (super.noSuchMethod(Invocation.method(
        #validate,
        [],
        {
          #field: field,
          #input: input,
        },
      )) as _i3.ValidationError?);
}

/// A class which mocks [AuthenticationUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationUsecase extends _i1.Mock
    implements _i4.AuthenticationUsecase {
  MockAuthenticationUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.AccountEntity> auth(_i4.AuthenticationParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #auth,
          [params],
        ),
        returnValue: _i5.Future<_i2.AccountEntity>.value(_FakeAccountEntity_0(
          this,
          Invocation.method(
            #auth,
            [params],
          ),
        )),
      ) as _i5.Future<_i2.AccountEntity>);
}

/// A class which mocks [SaveCurrentAccountUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSaveCurrentAccountUsecase extends _i1.Mock
    implements _i6.SaveCurrentAccountUsecase {
  MockSaveCurrentAccountUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<void> save(_i2.AccountEntity? account) => (super.noSuchMethod(
        Invocation.method(
          #save,
          [account],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}
