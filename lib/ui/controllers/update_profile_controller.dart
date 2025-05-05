import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/user_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class UpdateProfileController extends GetxController {


  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  bool _updateInProgress = false;
  bool get updateInProgress => _updateInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> updateProfile(String email, String firstName, String lastName, String mobile, String password) async {
    bool isSuccess = false;
    _updateInProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };
    if (password.isNotEmpty){
      requestBody['password'] = password;
    }
    if(_pickedImage != null) {
      List<int> imageBytes =  await _pickedImage!.readAsBytes();
      String encodedImage = base64UrlEncode(imageBytes);
      requestBody['photo'] = encodedImage;
    }
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );
    _updateInProgress = false;
    update();

    if (response.isSuccess) {
      UserModel updatedUser = UserModel.fromJson(requestBody);
      await AuthController.saveUserInformation(AuthController.token!, updatedUser);
      await AuthController.getUserInformation();
      update();
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    return isSuccess;
  }

  Future<bool> onTapPhotoPicker() async {
    bool isSuccess = false;
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      update();
    }
    return isSuccess;
  }
}