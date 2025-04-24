import 'package:flutter/material.dart';
import '../../common/color_extension.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: TColor.primaryText),
        ),
        centerTitle: true,
        title: Text(
          "About Us",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            "Welcome to Online Groceries!\n\n"
            "We are your one-stop shop for all your daily grocery needs. "
            "Our goal is to make shopping convenient, affordable, and enjoyable. "
            "With a wide range of products and fast delivery service, "
            "you can count on us to keep your kitchen stocked.\n\n"
            "Thank you for choosing us!",
            style: TextStyle(
              fontSize: 16,
              color: TColor.secondaryText,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
