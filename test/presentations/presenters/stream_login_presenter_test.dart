import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/scaffolding.dart';

import 'stream_login_presenter_test.mocks.dart';

///A RESPONSABILIDADE DO PRESENTER É GERENCIAMENTO DE ESTADO
///
///

class StreamLoginPresenter {
  final Validation _validation;

  StreamLoginPresenter({
    required Validation validation,
  }) : _validation = validation;

  void validateEmail(String email) {
    _validation.validate(field: 'email', value: email);
  }
}

abstract class Validation {
  String? validate({required String field, required value});
}

@GenerateMocks([Validation])
void main() {
  late StreamLoginPresenter sut;
  late MockValidation validation;

  late String email;
  late String password;

  setUp(() {
    email = faker.internet.email();
    password = faker.internet.password();

    validation = MockValidation();

    sut = StreamLoginPresenter(validation: validation);
  });

  test('Should call Validation with correct email', () {
    when(validation.validate(
            field: anyNamed('field'), value: anyNamed('value')))
        .thenReturn('any');

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });
}
