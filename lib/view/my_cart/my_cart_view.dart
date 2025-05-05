import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common/app_constants.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/cart_item_row.dart';
import 'package:grocery_store_flutter/view/my_cart/checkout_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:grocery_store_flutter/controllers/checkout_controller.dart';

class MyCartView extends StatefulWidget {
  const MyCartView({super.key});

  @override
  State<MyCartView> createState() => _MyCartViewState();
}

class _MyCartViewState extends State<MyCartView> {
  final checkoutController = Get.put(CheckoutController(), permanent: true);

  bool isLoading = true;
  bool hasError = false;
  Map<String, bool> updatingMap = {};
  Map<String, bool> deletingMap = {};

  @override
  void initState() {
    super.initState();
    fetchCartData();
  }

  Future<void> fetchCartData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? userId = sp.getString("userId");

    if (userId == null) {
      if (!mounted) return;
      setState(() {
        hasError = true;
        isLoading = false;
      });
      Get.snackbar('Error', 'User not logged in.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      return;
    }

    final cartUrl = '${AppConstants.baseUrl}/cart/$userId';

    try {
      final response = await http.get(Uri.parse(cartUrl));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> items = data['items'];

        checkoutController.cartItems.assignAll(items);
        checkoutController.calculateTotal();

        setState(() {
          isLoading = false;
          hasError = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        Get.snackbar('Error', 'Failed to load cart data.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        hasError = true;
        isLoading = false;
      });
      Get.snackbar('Error', 'Check your internet connection.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (newQuantity < 1) return;

    SharedPreferences sp = await SharedPreferences.getInstance();
    String? userId = sp.getString("userId");
    final url = '${AppConstants.baseUrl}/cart/$userId';

    if (!mounted) return;
    setState(() {
      updatingMap[productId] = true;
    });

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'productId': productId, 'quantity': newQuantity}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        await fetchCartData();
        if (mounted) {
          Get.snackbar('Success', 'Quantity updated',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);
        }
      } else {
        Get.snackbar('Error', 'Failed to update quantity',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      if (!mounted) return;
      Get.snackbar('Error', 'Error updating quantity',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }

    if (!mounted) return;
    setState(() {
      updatingMap[productId] = false;
    });
  }

  Future<void> removeCartItem(String productId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? userId = sp.getString("userId");
    final url = '${AppConstants.baseUrl}/cart/$userId';

    if (!mounted) return;
    setState(() {
      deletingMap[productId] = true;
    });

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'productId': productId}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        await fetchCartData();
        if (mounted) {
          Get.snackbar('Success', 'Item removed',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);
        }
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Error', data['message'] ?? 'Failed to remove item',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      if (!mounted) return;
      Get.snackbar('Error', 'Error removing item',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }

    if (!mounted) return;
    setState(() {
      deletingMap[productId] = false;
    });
  }

  void showCheckout() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (context) => CheckoutView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = checkoutController.cartItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "My Cart",
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (hasError)
            Center(child: Text('Failed to load cart data'))
          else if (cartItems.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 100, color: Colors.grey.shade400),
                  SizedBox(height: 16),
                  Text(
                    "Your cart is empty",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              padding: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
              itemCount: cartItems.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.black26),
              itemBuilder: (context, index) {
                var pObj = cartItems[index] as Map? ?? {};
                final productId = pObj['productId']['_id'];
                final isUpdating = updatingMap[productId] == true;
                final isDeleting = deletingMap[productId] == true;

                return CartItemRow(
                  pObj: pObj,
                  isUpdating: isUpdating,
                  isDeleting: isDeleting,
                  onRemove: () => removeCartItem(productId),
                  onIncrease: () =>
                      updateQuantity(productId, pObj['quantity'] + 1),
                  onDecrease: () =>
                      updateQuantity(productId, pObj['quantity'] - 1),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: () => showCheckout(),
                    height: 60,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19)),
                    minWidth: double.infinity,
                    color: TColor.primary,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Go to Checkout",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Text(
                            "₹${checkoutController.totalPrice.value.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
