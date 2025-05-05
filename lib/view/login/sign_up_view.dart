import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common/app_constants.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';
import 'package:grocery_store_flutter/view/login/sign_in_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isVisible = false;

  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool isLoading = false; // add this in your state
  Future<void> signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true); // show loading
      try {
        final url = Uri.parse('${AppConstants.baseUrl}/users/register');

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'firstName': txtFirstName.text,
            'lastName': txtLastName.text,
            'email': txtEmail.text,
            'mobile': txtMobile.text,
            'password': txtPassword.text,
            'authType': 'Email',
          }),
        );

        final responseData = jsonDecode(response.body);
        final responseMessage =
            responseData['message'] ?? 'No message from server';

        if (response.statusCode == 201) {
          Get.snackbar(
            'Success',
            responseMessage,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          Get.to(() => SignInView());
        } else {
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
        setState(() => isLoading = false); // hide loading
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
              key: _formKey,
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
                      "Sign up",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: media.height * 0.01),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter your credentials to continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: TColor.secondaryText,
                      ),
                    ),
                  ),
                  SizedBox(height: media.height * 0.05),
                  // First Name Field
                  TextFormField(
                    controller: txtFirstName,
                    decoration: InputDecoration(
                      labelText: "First Name",
                      hintText: "Enter your first name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.03),
                  // Last Name Field
                  TextFormField(
                    controller: txtLastName,
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      hintText: "Enter your last name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.03),
                  // Email Field
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
                        return 'Email is required';
                      }
                      if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.03),
                  // Mobile Field
                  TextFormField(
                    controller: txtMobile,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Mobile",
                      hintText: "Enter your mobile number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mobile number is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.03),
                  // Password Field
                  TextFormField(
                    controller: txtPassword,
                    obscureText: isVisible,
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
                          !isVisible ? Icons.visibility : Icons.visibility_off,
                          color: TColor.textTittle,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.02),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(text: "By continuing you agree to our "),
                        TextSpan(
                          text: "Terms of Service",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Terms of service clicked");
                            },
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Privacy policy clicked");
                            },
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.height * 0.05),
                  isLoading
                      ? CircularProgressIndicator()
                      : RoundButton(
                          title: "Sign Up",
                          onPressed: signUp,
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: media.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
