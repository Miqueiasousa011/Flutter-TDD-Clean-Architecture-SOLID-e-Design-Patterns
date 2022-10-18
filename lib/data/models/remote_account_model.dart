import '../../domain/entities/entities.dart';
import '../http/http.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel({required this.accessToken});

  factory RemoteAccountModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('accessToken')) {
      throw HttpError.invalidData;
    }

    return RemoteAccountModel(accessToken: json['accessToken']);
  }

  AccountEntity get toEntity => AccountEntity(token: accessToken);
}
