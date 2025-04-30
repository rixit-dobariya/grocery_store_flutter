import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/controllers/cart_controller.dart';
import 'package:grocery_store_flutter/view/home/product_details_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:grocery_store_flutter/common_widget/product_cell.dart';
import 'package:grocery_store_flutter/view/explore/filter_view.dart';
import '../../common/color_extension.dart';
import '../../common/app_constants.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController txtSearch = TextEditingController();
  List productList = [];
  List filteredProductList = [];
  bool isLoading = true;
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      var url = Uri.parse('${AppConstants.baseUrl}/products');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          productList = data;
          filteredProductList = data;
        });
      } else {
        Get.snackbar(
          'Error',
          'Failed to load products: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProductList = productList;
      });
    } else {
      setState(() {
        filteredProductList = productList.where((item) {
          final name = item["productName"]?.toString().toLowerCase() ?? "";
          return name.contains(query.toLowerCase());
        }).toList();
      });
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
              size: 30, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FilterView()),
            ),
            icon: const Icon(Icons.filter_alt_rounded,
                size: 27, color: Colors.black),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xffF2F3F2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: txtSearch,
            onChanged: filterSearchResults,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () {
                  txtSearch.text = "";
                  filterSearchResults("");
                  FocusScope.of(context).unfocus();
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                color: TColor.placeholder,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: filteredProductList.length,
              itemBuilder: (context, index) {
                var product =
                    filteredProductList[index] as Map<String, dynamic>;
                return Obx(
                  () => ProductCell(
                    pObj: product,
                    onPressed: () {
                      Get.to(() => ProductDetailsView());
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
