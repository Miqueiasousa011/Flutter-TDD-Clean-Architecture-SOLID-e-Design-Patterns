abstract class Validation {
  ValidationError? validate({
    required String field,
    required Map<String, dynamic> input,
  });
}

enum ValidationError { requiredField, invalidField }
