import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/line_textfield.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';
import 'package:grocery_store_flutter/view/login/sign_up_view.dart';
import 'package:grocery_store_flutter/view/main_tab/main_tab_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
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
                    "Login",
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
                    "Enter your email and password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: TColor.secondaryText,
                    ),
                  ),
                ),
                SizedBox(height: media.height * 0.05),
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
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  height: media.height * 0.01,
                ),
                RoundButton(
                  title: "Log In",
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainTabView()));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't you have an account?",
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpView()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: media.height * 0.05,
                ),
                RoundIconButton(
                  title: "Continue With Google",
                  icon: "assets/img/google_logo.png",
                  bgColor: Color(0xff5383EC),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
