import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common/app_constants.dart';
import 'package:grocery_store_flutter/controllers/cart_controller.dart';
import 'package:grocery_store_flutter/controllers/category_controller.dart';
import 'package:grocery_store_flutter/view/explore/search_view.dart';
import 'package:http/http.dart' as http;
import 'package:grocery_store_flutter/common_widget/category_cell.dart';
import 'package:grocery_store_flutter/common_widget/product_cell.dart';
import 'package:grocery_store_flutter/common_widget/section_view.dart';
import 'package:grocery_store_flutter/view/home/product_details_view.dart';

import '../../common/color_extension.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtSearch = TextEditingController();
  bool isVisible = false;
  List<dynamic> bannersArr = [];
  List<dynamic> exclusiveOfferArr = [];
  List<dynamic> bestSellingArr = [];
  final CartController cartController = Get.put(CartController());
  final CategoryController categoryController = Get.put(CategoryController());
  @override
  void initState() {
    super.initState();
    fetchBanners();
    categoryController.fetchCategories();
    fetchExclusiveOffers();
    fetchBestSellingProducts();
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      fetchBanners(),
      categoryController.fetchCategories(),
      fetchExclusiveOffers(),
      fetchBestSellingProducts(),
    ]);
  }

  Future<void> fetchExclusiveOffers() async {
    try {
      var url = Uri.parse('${AppConstants.baseUrl}/products/latest');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (mounted) {
          setState(() {
            exclusiveOfferArr = data;
          });
        }
      } else {
        showError("Failed to load exclusive offers");
      }
    } catch (e) {
      showError("Error fetching exclusive offers: $e");
    }
  }

  Future<void> fetchBestSellingProducts() async {
    try {
      var url = Uri.parse('${AppConstants.baseUrl}/products/trending');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (mounted) {
          setState(() {
            bestSellingArr = data;
          });
        }
      } else {
        showError("Failed to load best selling products");
      }
    } catch (e) {
      showError("Error fetching best selling products: $e");
    }
  }

  Future<void> fetchBanners() async {
    try {
      var url =
          Uri.parse('${AppConstants.baseUrl}/banners'); // Example endpoint
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (mounted) {
          setState(() {
            bannersArr =
                data.where((banner) => banner['type'] == 'slider').toList();
          });
        }
      } else {
        showError("Failed to load banners");
      }
    } catch (e) {
      showError("Error fetching banners: $e");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // same Logo, Search bar, Banner
                SizedBox(height: media.height * 0.025),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    'assets/img/color_logo.png',
                    fit: BoxFit.contain,
                    width: media.width * 0.1,
                    height: media.width * 0.1,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F3F2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchView()),
                        );
                      },
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xffF2F3F2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(13),
                              child: Icon(Icons.search_rounded, size: 20),
                            ),
                            Text(
                              "Search store",
                              style: TextStyle(
                                color: TColor.placeholder,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 130,
                    child: bannersArr.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : PageView.builder(
                            itemCount: bannersArr.length,
                            controller: PageController(),
                            itemBuilder: (context, index) {
                              var banner = bannersArr[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0XFFF2F3F2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      banner[
                                          'bannerImage'], // assuming this is the key
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),

                // Exclusive Offers
                SectionView(
                  title: "Exclusive Offers",
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  onPressed: () {
                    Get.to(() => SearchView());
                  },
                ),
                SizedBox(
                  height: 230,
                  child: exclusiveOfferArr.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          itemCount: exclusiveOfferArr.length,
                          itemBuilder: (context, index) {
                            var product = exclusiveOfferArr[index];
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
                              ),
                            );
                          },
                        ),
                ),

                // Best Selling
                SectionView(
                  title: "Best Selling",
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  onPressed: () {
                    Get.to(() => SearchView());
                  },
                ),
                SizedBox(
                  height: 230,
                  child: bestSellingArr.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          itemCount: bestSellingArr.length,
                          itemBuilder: (context, index) {
                            var product = bestSellingArr[index];
                            return Obx(
                              () => ProductCell(
                                pObj: product,
                                onPressed: () {
                                  Get.to(() =>
                                      ProductDetailsView(product: product));
                                },
                                onCart: () {
                                  cartController.addToCart(product["_id"]);
                                },
                                isLoading: cartController.loadingProductIds
                                    .contains(product["_id"]),
                              ),
                            );
                          },
                        ),
                ),

                // Groceries (dynamic from API)
                SectionView(
                  title: "Groceries",
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  onPressed: () {},
                  isShowAllButton: false,
                ),
                SizedBox(
                  height: 100,
                  child: categoryController.categories.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Obx(
                          () {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              itemCount: categoryController.categories.length,
                              itemBuilder: (context, index) {
                                var category =
                                    categoryController.categories[index];
                                return CategoryCell(
                                  category: category,
                                  onPressed: () {},
                                );
                              },
                            );
                          },
                        ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
