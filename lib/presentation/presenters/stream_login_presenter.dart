// import 'dart:async';
// import 'dart:ui';

// import 'package:fordev/domain/helpers/helpers.dart';
// import 'package:fordev/ui/pages/login/login.dart';

// import '../../domain/usecases/usecases.dart';
// import '../protocols/protocols.dart';

// class StreamLoginPresenter implements LoginPresenter {
//   StreamLoginPresenter({
//     required Validation validation,
//     required AuthenticationUsecase authenticationUsecase,
//   })  : _validation = validation,
//         _authenticationUsecase = authenticationUsecase;

//   final Validation _validation;
//   final AuthenticationUsecase _authenticationUsecase;

//   final _controller = StreamController<LoginState>.broadcast();

//   final _state = LoginState();

//   @override
//   Stream<String?> get emailErrorStream =>
//       _controller.stream.map((state) => state.emailError).distinct();

//   @override
//   Stream<String?> get passwordErrorStream =>
//       _controller.stream.map((state) => state.passwordError).distinct();

//   @override
//   Stream<bool> get isFormValidController =>
//       _controller.stream.map((state) => state.isFormValid).distinct();

//   @override
//   Stream<bool> get isLoadingController =>
//       _controller.stream.map((state) => state.isLoading).distinct();

//   @override
//   Stream<String?> get mainErrorController =>
//       _controller.stream.map((state) => state.mainError);

//   @override
//   void validateEmail(String? email) {
//     _state.email = email;
//     _state.emailError = _validation.validate(field: 'email', value: email);
//     _addState(_state);
//   }

//   @override
//   void validatePassword(String? password) {
//     _state.password = password;
//     _state.passwordError =
//         _validation.validate(field: 'password', value: password);
//     _addState(_state);
//   }

//   @override
//   Future<void> auth() async {
//     final params = AuthenticationParams(
//       email: _state.email!,
//       password: _state.password!,
//     );
//     _state.isLoading = true;
//     _addState(_state);
//     try {
//       await _authenticationUsecase.auth(params);
//     } on DomainError catch (e) {
//       _state.mainError = e.description;
//     } finally {
//       _state.isLoading = false;
//       _addState(_state);
//     }
//   }

//   void _addState(LoginState state) {
//     if (_controller.isClosed) return;
//     _controller.add(_state);
//   }

//   @override
//   Future<void> dispose() async {
//     return await _controller.close();
//   }

//   @override
//   void addListener(VoidCallback listener) {}

//   @override
//   void removeListener(VoidCallback listener) {}

//   @override
//   Stream<String?> get navigateToStream => throw UnimplementedError();
// }

// class LoginState {
//   String? email;
//   String? password;

//   String? emailError;
//   String? passwordError;
//   String? mainError;

//   bool isLoading = false;

//   bool get isFormValid =>
//       email != null &&
//       password != null &&
//       emailError == null &&
//       passwordError == null;
// }
