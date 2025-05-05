import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_widget/my_order_row.dart';
import '../../common/color_extension.dart';
import 'my_order_detail_view.dart';

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({super.key});

  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? userId = sp.getString("userId");

    if (userId == null || userId.isEmpty) {
      Get.snackbar("Error", "User ID not found in SharedPreferences");
      return;
    }

    final Uri url = Uri.parse("${AppConstants.baseUrl}/orders/user/$userId");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          orders = jsonData['orders'] ?? [];
          isLoading = false;
        });
      } else {
        Get.snackbar("Error", "Failed to load orders");
        return;
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Image.asset("assets/img/back.png", width: 20, height: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text("My Orders",
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(
                  child: Text("No Any Order Placed",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];
                    return MyOrderRow(
                      orderData: order,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MyOrdersDetailView(orderId: order["_id"]),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
