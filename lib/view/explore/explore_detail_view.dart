import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/controllers/cart_controller.dart';
import 'package:grocery_store_flutter/view/home/product_details_view.dart';
import 'package:http/http.dart' as http;
import 'package:grocery_store_flutter/common_widget/product_cell.dart';
import 'package:grocery_store_flutter/view/explore/filter_view.dart';
import '../../common/color_extension.dart';
import '../../models/category_model.dart';
import '../../common/app_constants.dart'; // assuming this has your baseUrl

class ExploreDetailsView extends StatefulWidget {
  final CategoryModel category;

  const ExploreDetailsView({super.key, required this.category});

  @override
  State<ExploreDetailsView> createState() => _ExploreDetailsViewState();
}

class _ExploreDetailsViewState extends State<ExploreDetailsView> {
  List<Map<String, dynamic>> products = [];
  final CartController cartController = Get.put(CartController());
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory();
  }

  Future<void> fetchProductsByCategory() async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/products/category/${widget.category.id}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          products = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        Get.snackbar("Error", "Failed to load products: ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching products: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left_rounded,
              size: 25, color: Colors.black),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => FilterView()));
        //     },
        //     icon: const Icon(Icons.filter_alt_rounded,
        //         size: 25, color: Colors.black),
        //   )
        // ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.category.name,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text("No products found"))
              : GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Obx(
                      () => ProductCell(
                        pObj: product,
                        onPressed: () {
                          Get.to(() => ProductDetailsView(
                                product: product,
                              ));
                        },
                        onCart: () {
                          cartController.addToCart(product["_id"]);
                        },
                        isLoading: cartController.loadingProductIds
                            .contains(product["_id"]),
                        margin: 0,
                        weight: double.maxFinite,
                      ),
                    );
                  },
                ),
    );
  }
}
