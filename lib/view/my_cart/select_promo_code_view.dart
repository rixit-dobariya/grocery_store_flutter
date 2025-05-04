import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../common/color_extension.dart';
import '../../common/app_constants.dart';
import '../../controllers/checkout_controller.dart'; // <-- Add this import

class SelectPromoCodeView extends StatefulWidget {
  const SelectPromoCodeView({super.key});

  @override
  State<SelectPromoCodeView> createState() => _SelectPromoCodeViewState();
}

class _SelectPromoCodeViewState extends State<SelectPromoCodeView> {
  final CheckoutController checkoutController =
      Get.find(); // Get existing controller
  List<Map<String, dynamic>> promoCodes = [];
  bool isLoading = true;
  String? selectedPromoId;

  @override
  void initState() {
    super.initState();
    selectedPromoId = checkoutController.promoCode.value?['id'];
    fetchPromoCodes();
  }

  Future<void> fetchPromoCodes() async {
    try {
      var url = Uri.parse('${AppConstants.baseUrl}/offers');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List data = json.decode(response.body);

        // Filter only active offers based on activeStatus
        List filtered =
            data.where((item) => item["activeStatus"] == true).toList();

        setState(() {
          promoCodes = filtered.map<Map<String, dynamic>>((item) {
            return {
              "id": item["_id"],
              "name": item["offerCode"],
              "discount": item["discount"],
              "description": item["offerDescription"],
              "maxDiscount": item["maxDiscount"],
              "minimumOrder": item["minimumOrder"],
              "activeStatus": item["activeStatus"],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load promo codes");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching promo codes: $e");
    }
  }

  void onPromoSelected(Map<String, dynamic> promo) {
    final orderTotal = checkoutController.totalPrice.value;

    if (orderTotal < promo["minimumOrder"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Invalid Promo Code: Minimum order ₹${promo["minimumOrder"]} required."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      selectedPromoId = promo["id"];
      checkoutController.promoCode.value = promo;
      checkoutController.calculateTotal();
    });
    Navigator.pop(context); // Go back to checkout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset("assets/img/back.png", width: 20, height: 20),
        ),
        centerTitle: true,
        title: Text(
          "Promo Code",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : promoCodes.isEmpty
              ? Center(
                  child: Text(
                    "No Promo Codes Available",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  itemCount: promoCodes.length,
                  itemBuilder: (context, index) {
                    final promo = promoCodes[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedPromoId == promo["id"]
                              ? TColor.primary
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      promo["name"] ?? "",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: TColor.primaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      promo["description"] ?? "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: TColor.secondaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (promo["discount"] != null &&
                                        promo["discount"] > 0)
                                      Text(
                                        "${promo["discount"]}% OFF",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Min Order: ₹${promo["minimumOrder"]}, Max Discount: ₹${promo["maxDiscount"]}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: TColor.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  onPromoSelected(promo); // Set in controller
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: TColor.primary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Apply",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                ),
    );
  }
}
