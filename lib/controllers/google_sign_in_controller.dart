import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_store_flutter/common/app_constants.dart';
import 'package:grocery_store_flutter/view/main_tab/main_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GoogleSignInController extends GetxController {
  var isLoading = false.obs;
  var user = Rx<User?>(null);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // Step 1: Let user pick Google account
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return; // User canceled
      }

      final email = googleUser.email;

      // Step 2: Check if email exists in your backend
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/users/check-email"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['exists'] == true) {
        // User already registered via email/password
        Get.snackbar(
          "Account Exists",
          "This account is registered using email/password. Please login using those credentials.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Step 3: Continue with Google authentication (since user is new)
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      user.value = firebaseUser;

      if (firebaseUser != null) {
        // Call your backend to complete login/registration
        final loginResponse = await http.post(
          Uri.parse("${AppConstants.baseUrl}/users/google-login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "email": firebaseUser.email,
            "authType": "Google",
          }),
        );

        final loginData = jsonDecode(loginResponse.body);

        if (loginResponse.statusCode == 200 ||
            loginResponse.statusCode == 201) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("userId", loginData["userId"]);
          await prefs.setString("email", loginData["email"]);
          await prefs.setString("authType", "Google");

          Get.snackbar(
            "Login Successful",
            "Welcome, ${firebaseUser.displayName ?? firebaseUser.email}",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.to(() => MainTabView());
        } else {
          Get.snackbar(
            "Login Failed",
            loginData["message"] ?? "Unknown error occurred",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Google Sign-In error: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
    user.value = null;
  }
}
