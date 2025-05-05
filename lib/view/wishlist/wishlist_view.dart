import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common/app_constants.dart';
import 'package:grocery_store_flutter/controllers/cart_controller.dart';
import 'package:grocery_store_flutter/view/home/product_details_view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widget/wishlist_row.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  List<dynamic> products = [];
  bool isLoading = true;
  String? userId;
  Set<String> deletingProductIds = {};
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    if (userId != null) {
      fetchWishlist();
    } else {
      if (!mounted) return;
      setState(() => isLoading = false);
      Get.snackbar('Error', 'User ID not found in SharedPreferences',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> fetchWishlist() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/wishlist/$userId'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final wishlist = data['wishlist'];

        setState(() {
          products = wishlist['productIds'];
          isLoading = false;
        });
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Error', data['message'] ?? 'Failed to load wishlist',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      Get.snackbar('Error', 'Server error',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      setState(() => isLoading = false);
    }
  }

  void removeItem(String productId) async {
    if (!mounted) return;
    setState(() => deletingProductIds.add(productId));

    try {
      final response = await http.delete(
        Uri.parse('${AppConstants.baseUrl}/wishlist/$userId/remove'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'productId': productId}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Item removed from wishlist',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
        fetchWishlist();
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Error', data['message'] ?? 'Failed to remove item',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      if (!mounted) return;
      Get.snackbar('Error', 'Server error',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    } finally {
      if (!mounted) return;
      setState(() => deletingProductIds.remove(productId));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (products.isEmpty) {
      return const Center(child: Text('Your wishlist is empty'));
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Obx(() => WishlistRow(
              product: product,
              onPressed: () => removeItem(product["_id"]),
              onViewDetails: () =>
                  Get.to(() => ProductDetailsView(product: product)),
              onAddToCart: () => cartController.addToCart(product["_id"]),
              isAddToCartLoading:
                  cartController.loadingProductIds.contains(product["_id"]),
              isDeleteLoading: deletingProductIds.contains(product["_id"]),
            ));
      },
    );
  }
}
