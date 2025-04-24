import 'user_model.dart';

class LoginModel {
  late final String status;
  late final String token;
  late final UserModel userModel;

  LoginModel.fromJson(Map<String, dynamic> jsonData) {
    status = jsonData['status'] ?? '';
    token = jsonData['token'] ?? '';
    userModel = UserModel.fromJson(jsonData['data'] ?? {});
  }
}