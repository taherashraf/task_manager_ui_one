import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_ui_one/ui/controllers/register_controller.dart';

import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailTEditingController =
  TextEditingController();
  final TextEditingController _firstNameTEditingController =
  TextEditingController();
  final TextEditingController _lastNameTEditingController =
  TextEditingController();
  final TextEditingController _mobileEditingController =
  TextEditingController();
  final TextEditingController _passwordTEditingController =
  TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegisterController registerController = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Text(
                    'Join With Us',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: _emailTEditingController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    textInputAction: TextInputAction.next,
                    controller: _firstNameTEditingController,
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
                    textInputAction: TextInputAction.next,
                    controller: _lastNameTEditingController,
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
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    controller: _mobileEditingController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    controller: _passwordTEditingController,
                    decoration: InputDecoration(hintText: 'Password'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if ((value?.isEmpty ?? true) && (value!.length < 6)) {
                        return 'Enter your password more than 6 letters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  GetBuilder<RegisterController>(
                    builder: (controller) {
                      return Visibility(
                        visible: controller.registrationInProgress == false,
                        replacement: Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: _onTapSubmitButton,
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(text: "Have an account? "),
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  _onTapSignInButton, // cascade operation double
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _registerUser();
    }
  }

  Future<void> _registerUser() async {
    final bool isSuccess = await registerController.registerUser(
        _emailTEditingController.text.trim(),
        _firstNameTEditingController.text.trim(),
        _lastNameTEditingController.text.trim(), _mobileEditingController.text.trim(),
        _passwordTEditingController.text);

    if (isSuccess) {
      _clearText();
      showSnackBarMessage(context, 'Registration Successfully Completed');
    } else {
      showSnackBarMessage(context, registerController.errorMessage!, true);
    }

  }

  void _clearText() {
    _emailTEditingController.clear();
    _firstNameTEditingController.clear();
    _lastNameTEditingController.clear();
    _mobileEditingController.clear();
    _passwordTEditingController.clear();
  }

  @override
  void dispose() {
    _emailTEditingController.dispose();
    _firstNameTEditingController.dispose();
    _lastNameTEditingController.dispose();
    _mobileEditingController.dispose();
    _passwordTEditingController.dispose();
    super.dispose();
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }
}
