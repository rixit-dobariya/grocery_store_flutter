import 'package:flutter/material.dart';
import '../../common_widget/line_textfield.dart';
import '../../common_widget/round_button.dart';

import '../../common/color_extension.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  // Controllers for password fields
  final TextEditingController txtCurrentPassword = TextEditingController();
  final TextEditingController txtNewPassword = TextEditingController();
  final TextEditingController txtConfirmPassword = TextEditingController();

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    txtCurrentPassword.dispose();
    txtNewPassword.dispose();
    txtConfirmPassword.dispose();
    super.dispose();
  }

  // Function to update password
  void updatePassword() {
    // You can add validation or API call here for updating the password
    if (txtNewPassword.text == txtConfirmPassword.text) {
      // Proceed with updating the password logic here
      Navigator.pop(context); // Close the screen after successful update
    } else {
      // Show an error message if passwords don't match
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Passwords do not match"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              "assets/img/back.png",
              width: 20,
              height: 20,
            )),
        centerTitle: true,
        title: Text(
          "Change Password",
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              // Current Password field
              LineTextField(
                title: "Current Password",
                placeholder: "Enter your current password",
                obscureText: true,
                controller: txtCurrentPassword,
              ),
              const SizedBox(height: 15),

              // New Password field
              LineTextField(
                title: "New Password",
                placeholder: "Enter your new password",
                obscureText: true,
                controller: txtNewPassword,
              ),
              const SizedBox(height: 15),

              // Confirm Password field
              LineTextField(
                title: "Confirm Password",
                obscureText: true,
                placeholder: "Confirm your new password",
                controller: txtConfirmPassword,
              ),
              const SizedBox(height: 25),

              // Set Password button
              RoundButton(
                title: "Set",
                onPressed: updatePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
