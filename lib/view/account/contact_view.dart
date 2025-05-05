import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../common/color_extension.dart';
import '../../common/app_constants.dart';
import '../../common_widget/round_button.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPhone = TextEditingController();
  final TextEditingController txtMessage = TextEditingController();

  String contactEmail = '';
  String contactNumber = '';
  bool isLoading = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchContactData();
  }

  Future<void> fetchContactData() async {
    final url = Uri.parse('${AppConstants.baseUrl}/contact');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          contactEmail = data['contactEmail'] ?? '';
          contactNumber = data['contactNumber'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    txtName.dispose();
    txtEmail.dispose();
    txtPhone.dispose();
    txtMessage.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isSubmitting = true);

    final url = Uri.parse('${AppConstants.baseUrl}/responses');
    final body = {
      "name": txtName.text.trim(),
      "email": txtEmail.text.trim(),
      "phone": txtPhone.text.trim(),
      "message": txtMessage.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      setState(() => isSubmitting = false);

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Message sent successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        Navigator.pop(context); // Or clear the form
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          data['message'] ?? 'Something went wrong.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
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
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset("assets/img/back.png", width: 20, height: 20),
        ),
        centerTitle: true,
        title: Text(
          "Contact Us",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (contactEmail.isNotEmpty || contactNumber.isNotEmpty)
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 25),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Contact Info",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (contactEmail.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(Icons.email,
                                        color: TColor.primaryText),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        contactEmail,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: TColor.secondaryText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (contactNumber.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.phone,
                                        color: TColor.primaryText),
                                    const SizedBox(width: 8),
                                    Text(
                                      contactNumber,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: TColor.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: txtName,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              hintText: 'Enter your name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Name is required'
                                : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: txtEmail,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email address',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Email is required';
                              final emailRegex =
                                  RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value))
                                return 'Enter a valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: txtPhone,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              hintText: 'Enter your phone number',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Phone is required';
                              if (value.length < 8)
                                return 'Enter a valid phone number';
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: txtMessage,
                            decoration: const InputDecoration(
                              labelText: 'Message',
                              hintText: 'Write your message',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Message cannot be empty'
                                : null,
                          ),
                          const SizedBox(height: 25),
                          isSubmitting
                              ? const Center(child: CircularProgressIndicator())
                              : RoundButton(
                                  title: "Send Message",
                                  onPressed: sendMessage,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
