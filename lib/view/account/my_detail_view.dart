import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common/app_constants.dart';
import 'package:grocery_store_flutter/view/account/change_password_view.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

class MyDetailView extends StatefulWidget {
  const MyDetailView({super.key});

  @override
  State<MyDetailView> createState() => _MyDetailViewState();
}

class _MyDetailViewState extends State<MyDetailView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController txtUsername;
  late TextEditingController txtMobile;
  late TextEditingController txtFirstName;
  late TextEditingController txtLastName;

  late String userId;
  String? profilePictureUrl;
  File? newProfileImage;

  bool isLoading = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    txtUsername = TextEditingController();
    txtFirstName = TextEditingController();
    txtLastName = TextEditingController();
    txtMobile = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";

    if (userId.isNotEmpty) {
      final response =
          await http.get(Uri.parse('${AppConstants.baseUrl}/users/$userId'));

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          txtUsername.text = userData['email'];
          txtFirstName.text = userData['firstName'];
          txtLastName.text = userData['lastName'];
          txtMobile.text = userData['mobile'];
          profilePictureUrl = userData['profilePicture'];
        });
      } else {
        Get.snackbar(
          'Error',
          "Failed to fetch user data",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        "User ID is not available",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        newProfileImage = File(picked.path);
      });
    }
  }

  Future<void> updateDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      var uri = Uri.parse('${AppConstants.baseUrl}/users/$userId');
      var request = http.MultipartRequest('PUT', uri);

      request.fields['firstName'] = txtFirstName.text.trim();
      request.fields['lastName'] = txtLastName.text.trim();
      request.fields['mobile'] = txtMobile.text.trim();
      request.fields['status'] = 'Active';

      if (profilePictureUrl != null && profilePictureUrl!.isNotEmpty) {
        request.fields['profilePicture'] = profilePictureUrl!;
      }

      if (newProfileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profilePicture',
          newProfileImage!.path,
          filename: path.basename(newProfileImage!.path),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          "User details updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        Navigator.pop(context);
      } else {
        Get.snackbar(
          'Error',
          "Failed to update user details",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        "Exception occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayImage = newProfileImage != null
        ? FileImage(newProfileImage!)
        : (profilePictureUrl == null || profilePictureUrl!.isEmpty)
            ? const AssetImage("assets/img/default_profile.png")
            : NetworkImage(profilePictureUrl!) as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset("assets/img/back.png", width: 20, height: 20)),
        centerTitle: true,
        title: Text(
          "My Details",
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: displayImage,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Tap to change profile picture",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 30),
                      _buildTextFormField(
                        title: "Email (Username)",
                        placeholder: "Enter your email",
                        controller: txtUsername,
                        enabled: false,
                        validator: null,
                      ),
                      const SizedBox(height: 15),
                      _buildTextFormField(
                        title: "First Name",
                        placeholder: "Enter your first name",
                        controller: txtFirstName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildTextFormField(
                        title: "Last Name",
                        placeholder: "Enter your last name",
                        controller: txtLastName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildTextFormField(
                        title: "Mobile Number",
                        placeholder: "Enter your mobile number",
                        controller: txtMobile,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mobile number cannot be empty';
                          }
                          if (value.length < 10) {
                            return 'Enter a valid mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      isSubmitting
                          ? CircularProgressIndicator()
                          : RoundButton(
                              title: "Update",
                              onPressed: updateDetails,
                            ),
                      const SizedBox(height: 25),
                      TextButton(
                        onPressed: () {
                          Get.to(() => ChangePasswordView());
                        },
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: TColor.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextFormField({
    required String title,
    required String placeholder,
    TextEditingController? controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
