import 'package:get/get.dart';

import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class ForgotPasswordVerifyController extends GetxController {

  bool _forgotPasswordEmailInProgress = false;
  bool get forgotPasswordEmailInProgress => _forgotPasswordEmailInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> forgetPasswordEmail(String emailVerify) async {

    bool isSuccess = false;
    _forgotPasswordEmailInProgress = true;
    update();

    final email = emailVerify;

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.recoveryEmailUrl(email),
    );

    _forgotPasswordEmailInProgress = false;
    update();

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    return isSuccess;
  }


}