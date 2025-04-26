import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/view/login/sign_in_view.dart';
import 'package:grocery_store_flutter/view/main_tab/main_tab_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    fireOpenApp();
  }

  void fireOpenApp() async {
    await Future.delayed(const Duration(seconds: 2));
    startApp();
  }

  void startApp() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      // Token exists → go to MainTabView using Get.offAll
      Get.offAll(() => const MainTabView());
    } else {
      // Token not found → go to SignInView using Get.offAll
      Get.offAll(() => const SignInView());
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.primary,
      body: Center(
        child: Image.asset(
          "assets/img/splash_logo.png",
          width: media.width * 0.7,
        ),
      ),
    );
  }
}
