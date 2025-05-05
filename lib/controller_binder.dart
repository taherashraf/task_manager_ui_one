import 'package:get/get.dart';
import 'package:task_manager_ui_one/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager_ui_one/ui/controllers/completed_task_controller.dart';
import 'package:task_manager_ui_one/ui/controllers/forgot_password_pin_controller.dart';
import 'package:task_manager_ui_one/ui/controllers/forgot_password_verify_controller.dart';
import 'package:task_manager_ui_one/ui/controllers/login_controller.dart';
import 'package:task_manager_ui_one/ui/controllers/new_count_task_controller.dart';
import 'package:task_manager_ui_one/ui/controllers/new_task_controller.dart';
import 'package:task_manager_ui_one/ui/controllers/progress_task_controller.dart';
import 'package:task_manager_ui_one/ui/controllers/register_controller.dart';
import 'package:task_manager_ui_one/ui/controllers/reset_password_controller.dart';
import 'package:task_manager_ui_one/ui/controllers/update_profile_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(NewTaskController());
    Get.put(NewCountTaskController());
    Get.put(UpdateProfileController());
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(()=> ForgotPasswordVerifyController());
    Get.lazyPut(()=> ForgotPasswordPinController());
    Get.lazyPut(()=> ResetPasswordController());
    Get.lazyPut(()=> ProgressTaskController());
    Get.lazyPut(()=> CompletedTaskController());
    Get.lazyPut(()=> CancelledTaskController());
  }

}