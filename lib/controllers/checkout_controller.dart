import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  var selectedAddress = {}.obs;

  var promoCode = {}.obs;

  var cartItems = [].obs;

  var totalPrice = 0.0.obs;
  var shippingCharge = 50.0.obs;
  var discountAmount = 0.0.obs;
  var subtotal = 0.0.obs;

  void calculateTotal() {
    double rawSubtotal = 0;
    for (var item in cartItems) {
      double salePrice = item['productId']['salePrice'] ?? 0;
      double discount = item['productId']['discount'] ?? 0;
      int quantity = item['quantity'] ?? 1;
      double finalPrice = salePrice - (salePrice * discount / 100);
      rawSubtotal += finalPrice * quantity;
    }

    // Apply promo code discount
    double promoDiscount = 0;
    if (promoCode.isNotEmpty) {
      double discountPercent = promoCode['discount'] ?? 0;
      double maxDiscount = promoCode['maxDiscount'] ?? 0;
      double minOrder = promoCode['minOrder'] ?? 0;

      promoDiscount =
          (rawSubtotal * discountPercent / 100).clamp(0, maxDiscount);
    }

    subtotal.value = rawSubtotal;
    discountAmount.value = promoDiscount;
    totalPrice.value = rawSubtotal - promoDiscount + shippingCharge.value;
  }

  // Clear everything after successful order
  void resetCheckout() {
    selectedAddress.clear();
    promoCode.clear();
    cartItems.clear();
    totalPrice.value = 0;
    discountAmount.value = 0;
  }
}
