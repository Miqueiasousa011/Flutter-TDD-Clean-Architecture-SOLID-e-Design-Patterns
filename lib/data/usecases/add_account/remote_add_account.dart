import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteAddAccount implements AddAccountUsecase {
  final HttpClient _httpClient;
  final String _url;

  RemoteAddAccount({
    required HttpClient httpClient,
    required String url,
  })  : _httpClient = httpClient,
        _url = url;

  @override
  Future<AccountEntity> add(AddAccountParams params) async {
    final body = RemoteAddAccountParams.fromDomain(params).toMap();
    try {
      final response = await _httpClient.request(
        url: _url,
        method: 'post',
        body: body,
      );

      return RemoteAccountModel.fromJson(response!).toEntity;
    } on HttpError catch (e) {
      throw _handleError(e);
    }
  }

  DomainError _handleError(HttpError error) {
    switch (error) {
      case HttpError.forbiddenError:
        return DomainError.emailInUse;
      case HttpError.badRequest:
      case HttpError.notFound:
      case HttpError.serverError:
      default:
        return DomainError.unexpected;
    }
  }
}

class RemoteAddAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RemoteAddAccountParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory RemoteAddAccountParams.fromDomain(AddAccountParams params) {
    return RemoteAddAccountParams(
      name: params.name,
      email: params.email,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      };
}
