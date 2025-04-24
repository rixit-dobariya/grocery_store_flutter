import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/checkout_row.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';
import 'package:grocery_store_flutter/view/my_cart/error_view.dart';
import 'package:grocery_store_flutter/view/my_cart/order_accept_view.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Checkout",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: TColor.primaryText,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Colors.black26,
          ),
          CheckoutRow(
            title: "Delivery",
            value: "Select method",
            onPressed: () {},
          ),
          CheckoutRow(
            title: "Promo Code",
            value: "Select code",
            onPressed: () {
              // Navigator.push(
              //   context
              //   // MaterialPageRoute(
              //   //   builder: (context) => PromoCodeView(),
              //   // ),
              // );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    Text(
                      "Payment",
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 30,
                      color: TColor.primaryText,
                    ),
                  ],
                ),
              ),
            ],
          ),
          CheckoutRow(
            title: "Promo Code",
            value: "Pick discount",
            onPressed: () {},
          ),
          CheckoutRow(
            title: "Total Cost",
            value: "₹500.00",
            onPressed: () {},
          ),
          Divider(
            height: 1,
            color: Colors.black26,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: "By continuing you agree to our",
                  ),
                  TextSpan(
                    text: "Terms",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print("Terms of service clicked");
                      },
                    style: TextStyle(
                      color: TColor.primaryText,
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
                      color: TColor.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          RoundButton(
              title: "Place order",
              onPressed: () {
                Get.to(OrderAcceptView());
              }),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
