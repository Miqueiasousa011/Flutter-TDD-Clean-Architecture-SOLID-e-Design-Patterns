import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteAddAccount {
  final HttpClient _httpClient;
  final String _url;

  RemoteAddAccount({
    required HttpClient httpClient,
    required String url,
  })  : _httpClient = httpClient,
        _url = url;

  @override
  Future add(AddAccountParams params) async {
    final body = RemoteAddAccountParams.fromDomain(params).toMap();
    try {
      await _httpClient.request(url: _url, method: 'post', body: body);
    } on HttpError catch (e) {
      throw DomainError.unexpected;
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
