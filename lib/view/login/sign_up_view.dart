import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';

import '../../common_widget/line_textfield.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: media.height * 0.15,
                ),
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
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: media.height * 0.01,
                ),
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
                LineTextField(
                  title: "Username",
                  placeholder: "Enter your username",
                  controller: txtUsername,
                ),
                SizedBox(height: media.height * 0.03),
                LineTextField(
                  title: "Email",
                  placeholder: "Enter your email",
                  controller: txtEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: media.height * 0.03),
                LineTextField(
                  title: "Password",
                  placeholder: "Enter your password",
                  controller: txtPassword,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: isVisible,
                  right: IconButton(
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
                SizedBox(height: media.height * 0.02),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: "By continuing you agree to our ",
                      ),
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
                      TextSpan(
                        text: " and ",
                      ),
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
                SizedBox(
                  height: media.height * 0.05,
                ),
                RoundButton(
                  title: "Sign Up",
                  onPressed: () {},
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
                SizedBox(
                  height: media.height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
