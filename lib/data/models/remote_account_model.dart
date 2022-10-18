import 'package:fordev/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel({required this.accessToken});

  factory RemoteAccountModel.fromJson(Map<String, dynamic> json) {
    return RemoteAccountModel(accessToken: json['accessToken']);
  }

  AccountEntity get toEntity => AccountEntity(token: accessToken);
}
