import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';
import 'package:grocery_store_flutter/view/main_tab/main_tab_view.dart';

import '../../common/color_extension.dart';

class OrderAcceptView extends StatelessWidget {
  const OrderAcceptView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                "assets/img/order_accpeted.png",
                width: media.width * 0.7,
              ),
              const SizedBox(height: 40),
              Text(
                "Your Order has been\naccepted",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Your items has been placcd and is on\nit’s way to being processed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Spacer(),
              RoundButton(
                title: "Track Order",
                onPressed: () {
                  // You can add navigation or tracking logic here.
                },
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => MainTabView());
                },
                child: Text(
                  "Back to home",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
