import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/checkout_row.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';
import 'package:grocery_store_flutter/view/my_cart/select_address_view.dart';
import 'package:grocery_store_flutter/view/my_cart/select_promo_code_view.dart';
import '../../controllers/checkout_controller.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final checkoutController = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Obx(() {
        final addressText = checkoutController.selectedAddress.isNotEmpty
            ? "${checkoutController.selectedAddress['address'] ?? ''}, ..."
            : "Select address";

        final promoText = checkoutController.promoCode.isNotEmpty
            ? "${checkoutController.promoCode['name'] ?? ''}"
            : "Select code";

        final shippingCost =
            "₹${checkoutController.shippingCharge.value.toStringAsFixed(2)}";

        return Column(
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
            Divider(height: 1, color: Colors.black26),

            // Address
            CheckoutRow(
              title: "Delivery",
              value: addressText,
              onPressed: () {
                Get.to(() => SelectAddressView());
              },
            ),

            // Promo code
            CheckoutRow(
              title: "Promo Code",
              value: promoText,
              onPressed: () {
                Get.to(() => SelectPromoCodeView());
              },
            ),
// Subtotal
            CheckoutRow(
              title: "Subtotal",
              value: "₹${checkoutController.subtotal.value.toStringAsFixed(2)}",
              onPressed: () {},
              isButton: false,
            ),

// Discount
            Obx(() {
              if (checkoutController.discountAmount.value > 0) {
                return CheckoutRow(
                  title: "Promo Discount",
                  value:
                      "- ₹${checkoutController.discountAmount.value.toStringAsFixed(2)}",
                  onPressed: () {},
                  isButton: false,
                );
              } else {
                return const SizedBox.shrink();
              }
            }),

            // Shipping
            CheckoutRow(
              title: "Shipping",
              value: shippingCost,
              onPressed: () {},
              isButton: false,
            ),

            // Total cost
            CheckoutRow(
              title: "Total Cost",
              value:
                  "₹${checkoutController.totalPrice.value.toStringAsFixed(2)}",
              onPressed: () {},
              isButton: false,
            ),

            Divider(height: 1, color: Colors.black26),

            // Terms and Place Order Button
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
                    const TextSpan(text: "By continuing you agree to our "),
                    TextSpan(
                      text: "Terms",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => print("Terms of service clicked"),
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => print("Privacy policy clicked"),
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() {
              return checkoutController.isLoading.value
                  ? CircularProgressIndicator()
                  : RoundButton(
                      title: "Place order",
                      onPressed: () {
                        if (checkoutController.selectedAddress.isEmpty) {
                          Get.snackbar(
                              "Error", "Please select a delivery address");
                          return;
                        }

                        if (checkoutController.cartItems.isEmpty) {
                          Get.snackbar("Error", "Cart is empty");
                          return;
                        }

                        checkoutController
                            .calculateTotal(); // Ensure pricing is up-to-date
                        checkoutController
                            .createRazorpayOrder(); // Starts the payment process
                      },
                    );
            }),
            SizedBox(height: 15),
          ],
        );
      }),
    );
  }
}
