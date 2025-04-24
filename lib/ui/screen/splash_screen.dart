import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_management/ui/screen/bottom_nav_bar.dart';
import 'package:task_management/ui/utils/assets_path.dart';
import 'package:task_management/ui/widget/screen_background.dart';
import '../controller/auth_controller.dart';
import 'loginScreen.dart';

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
    await Future.delayed(const Duration(seconds: 2));

    final bool isLoggedIn = await AuthController.checkIfUserLoggedIn();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
        isLoggedIn ? const MainBottomNavBar() : const loginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen_background(
        child: Center(
          child: SvgPicture.asset(
            assets_path.logoSVG,
            width: 120,
          ),
        ),
      ),
    );
  }
}