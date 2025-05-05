import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_ui_one/ui/controllers/forgot_password_pin_controller.dart';
import 'package:task_manager_ui_one/ui/widgets/centered_circular_progress_indicator.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart';

class ForgotPasswordPinVerificationScreen extends StatefulWidget {
  const ForgotPasswordPinVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<ForgotPasswordPinVerificationScreen> createState() =>
      _ForgotPasswordPinVerificationScreenState();
}

class _ForgotPasswordPinVerificationScreenState
    extends State<ForgotPasswordPinVerificationScreen> {
  final TextEditingController _pinVerifyTEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ForgotPasswordPinController forgotPasswordPinController =
      Get.find<ForgotPasswordPinController>();

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
                  'Pin Verification',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'A 6 digit verification pin has been sent to your email address',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
                ),

                const SizedBox(height: 24),
                PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    /*activeColor: Colors.white,*/
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  controller: _pinVerifyTEditingController,
                  appContext: context,
                ),

                const SizedBox(height: 8),

                GetBuilder<ForgotPasswordPinController>(
                  builder: (controller) {
                    return Visibility(
                      visible:
                          controller.forgotPasswordEmailInProgress == false,
                      replacement: CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapSubmitButton,
                        child: Icon(Icons.arrow_circle_right_outlined),
                      ),
                    );
                  },
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

    final bool isSuccess = await forgotPasswordPinController.forgetPasswordPin(
      _pinVerifyTEditingController.text.trim(),
      widget.email,
    );

    if (isSuccess) {
      showSnackBarMessage(context, 'Otp Successfully Verified');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResetPasswordScreen(
                email: widget.email,
                otp: _pinVerifyTEditingController.text,
              ),
        ),
      );
    } else {
      showSnackBarMessage(
        context,
        forgotPasswordPinController.errorMessage!,
        true,
      );
    }
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (predicate) => false,
    );
  }

  @override
  void dispose() {
    _pinVerifyTEditingController.dispose();
    super.dispose();
  }
}
