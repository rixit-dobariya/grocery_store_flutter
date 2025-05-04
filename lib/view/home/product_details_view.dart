import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';
import 'package:grocery_store_flutter/controllers/cart_controller.dart';
import 'package:grocery_store_flutter/controllers/wishlist_controller.dart';
import 'package:http/http.dart' as http;
import '../../common/app_constants.dart';

class ProductDetailsView extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  bool _isDetailsExpanded = false;
  bool _isAddingToCart = false;
  int _quantity = 1;
  double _rating = 0.0;
  List<dynamic> _reviews = [];
  final CartController cartController = Get.put(CartController());
  final WishlistController wishlistController = Get.put(WishlistController());

  @override
  void initState() {
    super.initState();
    _rating =
        double.tryParse(widget.product['averageRating'].toString()) ?? 0.0;
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      var url = Uri.parse('${AppConstants.baseUrl}/review/');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"productId": widget.product["_id"]}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _reviews = data;
          });
        }
      } else {
        debugPrint("Failed to load reviews");
      }
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    var media = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: const Color(0xffF2F3F2),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.chevron_left_rounded,
                            color: Colors.black, size: 40),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share,
                              color: Colors.black, size: 25),
                        ),
                      ],
                    ),
                    Container(
                      height: media.width * 0.7,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Image.network(
                        product['productImage'] ?? '',
                        fit: BoxFit.contain,
                        width: media.width * 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['productName'] ?? '',
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Obx(
                          () => wishlistController.loadingWishlistProductIds
                                  .contains(product["_id"])
                              ? const Center(child: CircularProgressIndicator())
                              : IconButton(
                                  onPressed: () {
                                    wishlistController
                                        .addToWishlist(product["_id"]);
                                  },
                                  icon: const Icon(
                                      Icons.favorite_outline_rounded,
                                      size: 25),
                                ),
                        ),
                      ],
                    ),
                    // Text(
                    //   "₹${product['salePrice'] - product['salePrice'] * product['discount'] / 100}",
                    //   style: TextStyle(
                    //     color: TColor.secondaryText,
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => setState(() {
                            if (_quantity > 1) _quantity--;
                          }),
                          icon: Icon(Icons.remove,
                              size: 25, color: TColor.secondaryText),
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: TColor.placeholder.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "$_quantity",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _quantity++),
                          icon:
                              Icon(Icons.add, size: 25, color: TColor.primary),
                        ),
                        const Spacer(),
                        Text(
                          "₹${product['salePrice'] - product['salePrice'] * product['discount'] / 100}",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    // Product Detail Toggle
                    Row(
                      children: [
                        Expanded(
                          child: Text("Product Detail",
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        IconButton(
                          onPressed: () => setState(
                              () => _isDetailsExpanded = !_isDetailsExpanded),
                          icon: Icon(
                            _isDetailsExpanded
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_right_rounded,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    if (_isDetailsExpanded)
                      Text(
                        product['description'] ?? '',
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 15),
                    const Divider(height: 1),
                    const SizedBox(height: 8),

                    // Reviews
                    Row(
                      children: [
                        Text(
                          "Reviews (${_reviews.length})",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: TColor.primaryText,
                          ),
                        ),
                        const Spacer(),
                        RatingBarIndicator(
                          rating: _rating,
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: Color(0xffF3603F)),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                    if (_reviews.isEmpty)
                      const Text("No reviews yet.")
                    else
                      Column(
                        children: _reviews.map((review) {
                          return ListTile(
                            title: Text(review['userName'] ?? 'Anonymous'),
                            subtitle: Text(review['review'] ?? ''),
                            trailing: RatingBarIndicator(
                              rating: double.tryParse(
                                      review['rating'].toString()) ??
                                  0,
                              itemBuilder: (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 15.0,
                              direction: Axis.horizontal,
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 15),
                    Obx(
                      () => cartController.loadingProductIds
                              .contains(product["_id"])
                          ? const Center(child: CircularProgressIndicator())
                          : RoundButton(
                              title: "Add To Cart",
                              onPressed: () {
                                cartController.addToCart(product["_id"]);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
