import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_ui_one/ui/controllers/forgot_password_verify_controller.dart';
import 'package:task_manager_ui_one/ui/widgets/snack_bar_message.dart';

import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/screen_background.dart';
import 'forgot_password_pin_verification_screen.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key,});

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() =>
      _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState
    extends State<ForgotPasswordVerifyEmailScreen> {
  final TextEditingController _emailTEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ForgotPasswordVerifyController forgotPasswordVerifyController = Get.find<ForgotPasswordVerifyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Text(
                  'Your Email Address',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'A 6 digit verification pin will send to your email address',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
                ),

                const SizedBox(height: 24),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTEditingController,
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

                GetBuilder<ForgotPasswordVerifyController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.forgotPasswordEmailInProgress == false,
                      replacement: CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapSubmitButton,
                        child: Icon(Icons.arrow_circle_right_outlined),
                      ),
                    );
                  }
                ),
                const SizedBox(height: 8),
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
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _forgetPasswordEmail();
    }
  }

  Future<void> _forgetPasswordEmail() async {
    final bool isSuccess = await forgotPasswordVerifyController.forgetPasswordEmail(_emailTEditingController.text.trim());
    final String email = _emailTEditingController.text.trim();

    if (isSuccess) {
      showSnackBarMessage(context, 'OTP successfully sent to your email');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordPinVerificationScreen(email: email),
        ),
      );
    } else {
      showSnackBarMessage(context, forgotPasswordVerifyController.errorMessage!, true);
    }
  }

  // Future<void> _forgetPasswordEmail() async {
  //   _forgotPasswordEmailInProgress = true;
  //   setState(() {});
  //   final email = _emailTEditingController.text.trim();
  //
  //   final NetworkResponse response = await NetworkClient.getRequest(
  //     url: Urls.recoveryEmailUrl(email),
  //   );
  //
  //   _forgotPasswordEmailInProgress = false;
  //   setState(() {});
  //
  //   if (response.isSuccess) {
  //     showSnackBarMessage(context, 'OTP successfully sent to your email');
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ForgotPasswordPinVerificationScreen(email: email),
  //       ),
  //     );
  //   } else {
  //     showSnackBarMessage(context, response.errorMessage, true);
  //   }
  // }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEditingController.dispose();
    super.dispose();
  }
}
