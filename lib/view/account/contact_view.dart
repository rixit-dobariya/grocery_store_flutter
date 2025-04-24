import 'package:flutter/material.dart';
import '../../common_widget/line_textfield.dart';
import '../../common_widget/round_button.dart';
import '../../common/color_extension.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPhone = TextEditingController();
  final TextEditingController txtMessage = TextEditingController();

  @override
  void dispose() {
    txtName.dispose();
    txtEmail.dispose();
    txtPhone.dispose();
    txtMessage.dispose();
    super.dispose();
  }

  void sendMessage() {
    // Your message submission logic here
    Navigator.pop(context); // Simulating success for now
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
          ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              LineTextField(
                title: "Name",
                placeholder: "Enter your name",
                controller: txtName,
              ),
              const SizedBox(height: 15),
              LineTextField(
                title: "Email",
                placeholder: "Enter your email address",
                controller: txtEmail,
              ),
              const SizedBox(height: 15),
              LineTextField(
                title: "Phone Number",
                placeholder: "Enter your phone number",
                controller: txtPhone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
              LineTextField(
                title: "Message",
                placeholder: "Write your message",
                controller: txtMessage,
              ),
              const SizedBox(height: 25),
              RoundButton(
                title: "Send Message",
                onPressed: sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
