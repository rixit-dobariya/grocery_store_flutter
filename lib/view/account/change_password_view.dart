import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController txtCurrentPassword;
  late TextEditingController txtNewPassword;
  late TextEditingController txtConfirmPassword;

  bool isSubmitting = false;
  String? email;

  @override
  void initState() {
    super.initState();
    txtCurrentPassword = TextEditingController();
    txtNewPassword = TextEditingController();
    txtConfirmPassword = TextEditingController();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
    });
  }

  Future<void> updatePassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (email == null) {
      Get.snackbar('Error', 'User email not found',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => isSubmitting = true);

    final url = Uri.parse('${AppConstants.baseUrl}/users/update-password');
    final body = jsonEncode({
      'email': email,
      'currentPassword': txtCurrentPassword.text.trim(),
      'newPassword': txtNewPassword.text.trim(),
    });

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      setState(() => isSubmitting = false);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Password updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        Navigator.pop(context);
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          data['message'] ?? 'Failed to update password',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void dispose() {
    txtCurrentPassword.dispose();
    txtNewPassword.dispose();
    txtConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset(
            "assets/img/back.png",
            width: 20,
            height: 20,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Change Password",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: email == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextFormField(
                      title: "Current Password",
                      placeholder: "Enter your current password",
                      controller: txtCurrentPassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Current password cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextFormField(
                      title: "New Password",
                      placeholder: "Enter your new password",
                      controller: txtNewPassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'New password cannot be empty';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextFormField(
                      title: "Confirm Password",
                      placeholder: "Confirm your new password",
                      controller: txtConfirmPassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm password cannot be empty';
                        }
                        if (value != txtNewPassword.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    isSubmitting
                        ? const CircularProgressIndicator()
                        : RoundButton(
                            title: "Set",
                            onPressed: updatePassword,
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextFormField({
    required String title,
    required String placeholder,
    TextEditingController? controller,
    bool obscureText = false,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: placeholder,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
