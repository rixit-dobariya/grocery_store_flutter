import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/app_constants.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';
import 'package:grocery_store_flutter/controllers/google_sign_in_controller.dart';
import 'package:grocery_store_flutter/view/login/forgot_password_view.dart';
import 'package:grocery_store_flutter/view/login/sign_up_view.dart';
import 'package:grocery_store_flutter/view/main_tab/main_tab_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final GoogleSignInController _googleSignInController =
      GoogleSignInController();

  // Function to handle login logic
  Future<void> signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true); // Show loading indicator
      try {
        final response = await http.post(
          Uri.parse('${AppConstants.baseUrl}/users/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': txtEmail.text,
            'password': txtPassword.text,
          }),
        );

        final responseData = jsonDecode(response.body);
        final responseMessage =
            responseData['message'] ?? 'No message from server';

        if (response.statusCode == 200) {
          final token = responseData['token'];
          final userId = responseData['user']['_id'];
          // Save to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('userId', userId);
          await prefs.setString('email', txtEmail.text);
          // Success
          Get.snackbar(
            'Success',
            'Login successful!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          // Navigate to Main Tab view (or another screen as needed)
          Get.offAll(() => MainTabView());
        } else {
          // Error (invalid credentials, user not found, etc.)
          Get.snackbar(
            'Error',
            responseMessage,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An error occurred: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } finally {
        setState(() => isLoading = false); // Hide loading indicator
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey, // Attach form key for validation
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: media.height * 0.15),
                  Image.asset(
                    'assets/img/color_logo.png',
                    fit: BoxFit.contain,
                    width: media.width * 0.15,
                    height: media.width * 0.15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: media.height * 0.01),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter your email and password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: TColor.secondaryText,
                      ),
                    ),
                  ),
                  SizedBox(height: media.height * 0.05),

                  // Email TextFormField with validation
                  TextFormField(
                    controller: txtEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.03),

                  // Password TextFormField with validation
                  TextFormField(
                    controller: txtPassword,
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                          color: TColor.textTittle,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => ForgotPasswordView());
                      },
                    ),
                  ),
                  SizedBox(height: media.height * 0.01),

                  // Log In Button
                  Obx(
                    () {
                      return isLoading ||
                              _googleSignInController.isLoading.value
                          ? CircularProgressIndicator()
                          : RoundButton(
                              title: "Log In",
                              onPressed: signIn,
                            );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => SignUpView()); // Using GetX for routing
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: media.height * 0.05),

                  // Continue with Google Button
                  Obx(
                    () {
                      return isLoading ||
                              _googleSignInController.isLoading.value
                          ? CircularProgressIndicator() // Show loading indicator
                          : RoundIconButton(
                              title: "Continue With Google",
                              icon: "assets/img/google_logo.png",
                              bgColor: Color(0xff5383EC),
                              onPressed: () async {
                                await _googleSignInController
                                    .signInWithGoogle();
                              },
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
