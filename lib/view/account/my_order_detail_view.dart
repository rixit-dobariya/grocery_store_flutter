import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../common/app_constants.dart';
import '../../common/color_extension.dart';
import '../../common_widget/order_item_row.dart';
import '../../common_widget/popup_layout.dart';
import 'write_review_view.dart';

class MyOrdersDetailView extends StatefulWidget {
  final String orderId;

  const MyOrdersDetailView({Key? key, required this.orderId}) : super(key: key);

  @override
  _MyOrdersDetailViewState createState() => _MyOrdersDetailViewState();
}

class _MyOrdersDetailViewState extends State<MyOrdersDetailView> {
  late Map<String, dynamic> order;
  late List<Map<String, dynamic>> orderItems;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    orderItems = [];
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    final String url = '${AppConstants.baseUrl}/orders/${widget.orderId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          order = responseData['order'];
          orderItems =
              List<Map<String, dynamic>>.from(responseData['orderItems']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load order details.';
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred: $error';
      });
    }
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
          "My Order Detail",
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
          : errorMessage.isNotEmpty
              ? _showError(errorMessage)
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      _buildOrderInfoCard(),
                      const SizedBox(height: 15),
                      _buildAddressCard(),
                      const SizedBox(height: 15),
                      _buildOrderItemsList(),
                      const SizedBox(height: 15),
                      _buildAmountSummaryCard(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildOrderInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Order ID: #${order["_id"] ?? ''}",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                getPaymentStatus(order),
                style: TextStyle(
                  color: getPaymentStatusColor(order),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${order["orderDate"] ?? ''}",
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                getOrderStatus(order),
                style: TextStyle(
                  color: getOrderStatusColor(order),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow("Payment Type:", getPaymentType(order)),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery Address",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          // Display Full Name
          Text(
            "${order["delAddressId"]?["fullName"] ?? "N/A"}",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          // Display Address in a more readable format
          Text(
            "${order["delAddressId"]?["address"] ?? "N/A"}",
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${order["delAddressId"]?["city"] ?? "N/A"}, ${order["delAddressId"]?["state"] ?? "N/A"} - ${order["delAddressId"]?["pincode"] ?? "N/A"}",
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          // Display Phone Number
          _buildInfoRow(
              "Phone:", "${order["delAddressId"]?["phone"] ?? "N/A"}"),
        ],
      ),
    );
  }

  Widget _buildOrderItemsList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: orderItems.length,
      itemBuilder: (context, index) {
        var pObj = orderItems[index];

        // Parse price safely
        String priceStr = pObj['price']['\$numberDecimal'] ?? '0.0';
        double price = double.tryParse(priceStr) ?? 0.0;

        // Parse quantity safely
        int quantity = pObj["quantity"] is int
            ? pObj["quantity"]
            : int.tryParse(pObj["quantity"].toString()) ?? 0;

        double totalPrice = price * quantity;

        return OrderItemRow(
          imageUrl: pObj["productId"]?["productImage"] ?? '',
          name: pObj["productId"]?["productName"] ?? '',
          qty: quantity,
          totalPrice: totalPrice,
          showReviewButton:
              (order["orderStatus"] == "Delivered" && pObj["rating"] == 0.0),
          onWriteReviewPressed: () {
            // Implement the review writing functionality here
          },
        );
      },
    );
  }

  Widget _buildAmountSummaryCard() {
    double itemsTotal = 0;
    double totalDiscount = 0;

    for (var item in orderItems) {
      final price =
          double.tryParse(item['price']['\$numberDecimal'].toString()) ?? 0.0;
      final qty = double.tryParse(item['quantity'].toString()) ?? 0.0;
      final discount =
          double.tryParse(item['discount']['\$numberDecimal'].toString()) ??
              0.0;

      itemsTotal += price * qty;
      totalDiscount += discount;
    }

    final shipping = double.tryParse(
            order['shippingCharge']['\$numberDecimal'].toString()) ??
        0.0;
    final finalTotal = itemsTotal - totalDiscount + shipping;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAmountRow("Amount:", "\₹${itemsTotal.toStringAsFixed(2)}"),
          _buildAmountRow(
              "Delivery Cost:", "+ \₹${shipping.toStringAsFixed(2)}"),
          _buildAmountRow(
              "Discount:", "- \₹${totalDiscount.toStringAsFixed(2)}",
              isDiscount: true),
          const Divider(color: Colors.black12, thickness: 1),
          _buildAmountRow("Total:", "\₹${finalTotal.toStringAsFixed(2)}",
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: TColor.primaryText, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String title, String value,
      {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDiscount ? Colors.red : TColor.primaryText,
              fontSize: isTotal ? 22 : 18,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: isDiscount ? Colors.red : TColor.primaryText,
                fontSize: isTotal ? 22 : 18,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getPaymentStatus(Map<String, dynamic> order) =>
      order["paymentStatus"] == "Completed" ? "Paid" : "Unpaid";

  Color getPaymentStatusColor(Map<String, dynamic> order) =>
      order["paymentStatus"] == "Completed" ? Colors.green : Colors.red;

  String getOrderStatus(Map<String, dynamic> order) =>
      order["orderStatus"] ?? "Pending";

  Color getOrderStatusColor(Map<String, dynamic> order) {
    switch (order["orderStatus"]) {
      case "Delivered":
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String getPaymentType(Map<String, dynamic> order) =>
      (order["paymentMode"] ?? "Cash on Delivery").toString();

  Widget _showError(String errorMessage) {
    return Center(
      child: Text(
        errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }
}
