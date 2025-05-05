
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_ui_one/data/models/user_model.dart';
import 'package:task_manager_ui_one/ui/controllers/auth_controller.dart';
import 'package:task_manager_ui_one/ui/controllers/update_profile_controller.dart';
import 'package:task_manager_ui_one/ui/widgets/centered_circular_progress_indicator.dart';

import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEditingController =
  TextEditingController();
  final TextEditingController _firstNameTEditingController =
  TextEditingController();
  final TextEditingController _lastNameTEditingController =
  TextEditingController();
  final TextEditingController _mobileTEditingController =
  TextEditingController();
  final TextEditingController _passwordTEditingController =
  TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    UserModel userModel = AuthController.userModel!;
    _emailTEditingController.text = userModel.email;
    _firstNameTEditingController.text = userModel.firstName;
    _lastNameTEditingController.text = userModel.lastName;
    _mobileTEditingController.text = userModel.mobile;
  }

  UpdateProfileController updateProfileController = Get.find<
      UpdateProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(fromProfileScreen: true),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Update Profile',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(height: 24),
                  _buildPhotoPickerWidget(),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailTEditingController,
                    enabled: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      String email = value?.trim() ?? '';
                      if (EmailValidator.validate(email) == false) {
                        return 'enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameTEditingController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value
                          ?.trim()
                          .isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTEditingController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value
                          ?.trim()
                          .isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mobileTEditingController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    validator: (String? value) {
                      String phone = value?.trim() ?? '';
                      RegExp regExp = RegExp(r"^(?:\+?88|0088)?01[13-9]\d{8}$");
                      if (regExp.hasMatch(phone) == false) {
                        return 'Enter your valid mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEditingController,
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<UpdateProfileController>(
                    builder: (controller) {
                      return Visibility(
                        visible: controller.updateInProgress == false,
                        replacement: CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: _onTapSubmitButton,
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPickerWidget() {
    return GestureDetector(
      onTap: _onTapPhotoPicker,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Text('Photo', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 8),
            GetBuilder<UpdateProfileController>(
              builder: (controller) {
                return Text(
                  controller.pickedImage?.name ?? 'Select your Photo',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    final isSuccess = await updateProfileController.updateProfile(
        _emailTEditingController.text.trim(),
        _firstNameTEditingController.text.trim(),
        _lastNameTEditingController.text.trim(), _mobileTEditingController.text.trim(),
        _passwordTEditingController.text);

    if (isSuccess) {
      _passwordTEditingController.clear();
      showSnackBarMessage(context, 'Update Successfully Completed');
    } else {
      showSnackBarMessage(context, updateProfileController.errorMessage!, true);
    }
  }

  Future<void> _onTapPhotoPicker() async {
    await updateProfileController.onTapPhotoPicker();
  }

  @override
  void dispose() {
    _emailTEditingController.dispose();
    _firstNameTEditingController.dispose();
    _lastNameTEditingController.dispose();
    _mobileTEditingController.dispose();
    _passwordTEditingController.dispose();
    super.dispose();
  }
}
