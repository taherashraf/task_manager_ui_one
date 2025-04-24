import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager_ui_one/ui/controllers/auth_controller.dart';
import 'package:task_manager_ui_one/ui/screens/login_screen.dart';

import '../screens/update_profile_screen.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({super.key, this.fromProfileScreen});

  final bool? fromProfileScreen;

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme
        .of(context)
        .textTheme;
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: () {
          if (fromProfileScreen ?? false) {
            return;
          }
          _onTapUpdateProfile(context);
        },
        child: Row(
          children: [
            CircleAvatar(radius: 16,
              backgroundImage: _shouldShowImage(AuthController.userModel?.photo)
                  ? MemoryImage(
                  base64Decode(AuthController.userModel?.photo ?? '')) : null,),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userModel?.fulName ?? 'No Name',
                    style: _textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ), //?. safe unwrap
                  Text(
                    AuthController.userModel?.email ?? 'unknown',
                    style: _textTheme.bodySmall?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _onLogOutButton(context),
              icon: Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  bool _shouldShowImage(String? photo) {
    return photo != null && photo.isNotEmpty;
  }

  void _onTapUpdateProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
    );
  }

  Future<void> _onLogOutButton(BuildContext context) async {
    await AuthController.clearUserData();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
