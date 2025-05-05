import 'package:get/get.dart';

import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class ResetPasswordController extends GetxController {

  bool _resetPasswordInProgress = false;
  bool get resetPasswordInProgress => _resetPasswordInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> recoverResetPassword (String newPassword, String confirmPassword2, String otp, String email) async {

    bool isSuccess = false;
    _resetPasswordInProgress = true;
    update();

    final Map<String, dynamic> requestBody = {
      'email':email,
      'OTP': otp,
      'password': newPassword,
    };

    final NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.recoverResetPasswordUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _resetPasswordInProgress = false;
    update();

    return isSuccess;
  }


}