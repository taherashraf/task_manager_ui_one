import 'package:get/get.dart';

import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class RegisterController extends GetxController {

  bool _registrationInProgress = false;
  bool get registrationInProgress => _registrationInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> registerUser(
    String email,
    String firstName,
    String lastName,
    String mobile,
    String password,
  ) async {
    bool isSuccess = false;
    _registrationInProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.registerUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _registrationInProgress = false;
   update();

    return isSuccess;
  }
}
