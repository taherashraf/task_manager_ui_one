import 'package:get/get.dart';

import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class ForgotPasswordPinController extends GetxController {

  bool _forgotPasswordPinInProgress = false;
  bool get forgotPasswordEmailInProgress => _forgotPasswordPinInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> forgetPasswordPin (String otp, String email) async {

    bool isSuccess = false;
    _forgotPasswordPinInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.otpUrl(email, otp),
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _forgotPasswordPinInProgress = false;
    update();

    return isSuccess;
  }


}