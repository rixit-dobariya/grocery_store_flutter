import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widget/line_textfield.dart';
import '../../common_widget/round_button.dart';
import 'change_password_view.dart';

import '../../common/color_extension.dart';

class MyDetailView extends StatefulWidget {
  const MyDetailView({super.key});

  @override
  State<MyDetailView> createState() => _MyDetailViewState();
}

class _MyDetailViewState extends State<MyDetailView> {
  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtMobile = TextEditingController();
  final TextEditingController txtCountryCode =
      TextEditingController(); // For country code

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    txtUsername.dispose();
    txtName.dispose();
    txtMobile.dispose();
    txtCountryCode.dispose();
    super.dispose();
  }

  // Function to update user details
  void updateDetails() {
    // Example: Update logic or API call can be added here
    Navigator.pop(context); // Close the page after updating
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
          "My Details",
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
              // Username field
              LineTextField(
                title: "Username",
                placeholder: "Enter your username",
                controller: txtUsername,
              ),
              const SizedBox(height: 15),

              // Name field
              LineTextField(
                title: "Name",
                placeholder: "Enter your name",
                controller: txtName,
              ),
              const SizedBox(height: 15),

              // Mobile number field with country code input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mobile Number",
                    style: TextStyle(
                        color: TColor.textTittle,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      // Country code text box
                      Container(
                        width:
                            80, // Set a fixed width for the country code input
                        child: TextField(
                          controller: txtCountryCode,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "+1", // Example country code
                            hintStyle: TextStyle(
                                color: TColor.placeholder, fontSize: 17),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: txtMobile,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Mobile Number",
                            hintStyle: TextStyle(
                                color: TColor.placeholder, fontSize: 17),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 1,
                    color: const Color(0xffE2E2E2),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Update button
              RoundButton(
                title: "Update",
                onPressed: updateDetails,
              ),
              const SizedBox(height: 40),

              // Change password button
              TextButton(
                onPressed: () {
                  Get.to(() => const ChangePasswordView());
                },
                child: Text(
                  "Change Password",
                  style: TextStyle(
                      color: TColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
