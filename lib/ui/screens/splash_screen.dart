import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_ui_one/ui/controllers/auth_controller.dart';
import 'package:task_manager_ui_one/ui/screens/main_bottom_nav_screen.dart';
import '../utils/assets_path..dart';
import '../widgets/screen_background.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 2));

    final bool isLoggedIn = await AuthController.checkUserLoggedIn();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                isLoggedIn ? const MainBottomNavScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(child: SvgPicture.asset(AssetsPath.logoSvg, width: 120)),
      ),
    );
  }
}
