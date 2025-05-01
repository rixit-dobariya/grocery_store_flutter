import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/cart_item_row.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';
import 'package:grocery_store_flutter/view/my_cart/checkout_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCartView extends StatefulWidget {
  const MyCartView({super.key});

  @override
  State<MyCartView> createState() => _MyCartViewState();
}

class _MyCartViewState extends State<MyCartView> {
  List cartArr = [];
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
      setState(() {
        hasError = true;
        isLoading = false;
      });
      Get.snackbar('Error', 'User not logged in.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final cartUrl = '${AppConstants.baseUrl}/cart/$userId';

    try {
      final response = await http.get(Uri.parse(cartUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          cartArr = data['items'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        Get.snackbar('Error', 'Failed to load cart data. Please try again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      Get.snackbar(
          'Error', 'An error occurred. Please check your internet connection.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red, // Red color for errors
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (newQuantity < 1) return;

    SharedPreferences sp = await SharedPreferences.getInstance();
    String? userId = sp.getString("userId");
    final url = '${AppConstants.baseUrl}/cart/$userId';

    setState(() {
      updatingMap[productId] = true;
    });

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'productId': productId, 'quantity': newQuantity}),
      );

      if (response.statusCode == 200) {
        await fetchCartData();
        Get.snackbar('Success', 'Item quantity updated',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to update item quantity',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error updating quantity',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }

    setState(() {
      updatingMap[productId] = false;
    });
  }

  Future<void> removeCartItem(String productId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? userId = sp.getString("userId");
    final url = '${AppConstants.baseUrl}/cart/$userId';

    setState(() {
      deletingMap[productId] = true;
    });

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'productId': productId}),
      );

      if (response.statusCode == 200) {
        await fetchCartData();
        Get.snackbar('Success', 'Item removed from cart',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Error', data['message'] ?? 'Failed to remove item',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error removing item',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }

    setState(() {
      deletingMap[productId] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            fontWeight: FontWeight.w700,
          ),
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
          else
            ListView.separated(
                padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
                itemCount: cartArr.length,
                separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: Colors.black26,
                    ),
                itemBuilder: (context, index) {
                  var pObj = cartArr[index] as Map? ?? {};
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
                }),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    showCheckout();
                  },
                  height: 60,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19)),
                  minWidth: double.maxFinite,
                  elevation: 0.1,
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
                              color: Colors.white,
                            ),
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
                          "₹500", // Update to dynamic value as required
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showCheckout() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return CheckoutView();
      },
    );
  }
}
