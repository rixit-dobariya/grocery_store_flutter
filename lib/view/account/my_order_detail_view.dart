import 'package:flutter/material.dart';
import '../../common_widget/order_item_row.dart';
import '../../common_widget/popup_layout.dart';
import '../../common/color_extension.dart';
import 'write_review_view.dart';

class MyOrdersDetailView extends StatefulWidget {
  final Map<String, dynamic> mObj;

  const MyOrdersDetailView({super.key, required this.mObj});

  @override
  State<MyOrdersDetailView> createState() => _MyOrdersDetailViewState();
}

class _MyOrdersDetailViewState extends State<MyOrdersDetailView> {
  List<Map<String, dynamic>> cartList = [];

  @override
  void initState() {
    super.initState();
    // You can replace this with API call logic
    cartList = widget.mObj["cartItems"] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.mObj;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Order ID: #${order["orderId"] ?? ''}",
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
                          "${order["createdDate"] ?? ''}",
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
                  const SizedBox(height: 4),
                  Text(
                    "${order["address"] ?? ""}, ${order["city"] ?? ""}, ${order["state"] ?? ""}, ${order["postalCode"] ?? ""}",
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow("Delivery Type:", getDeliverType(order)),
                  _buildInfoRow("Payment Type:", getPaymentType(order)),
                ],
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: cartList.length,
              itemBuilder: (context, index) {
                var pObj = cartList[index];
                return OrderItemRow(
                  imageUrl: pObj["imageUrl"],
                  name: pObj["name"],
                  unitValue: pObj["unitValue"],
                  unitName: pObj["unitName"],
                  qty: pObj["qty"],
                  itemPrice: pObj["itemPrice"],
                  totalPrice: pObj["totalPrice"],
                  showReviewButton:
                      (order["orderStatus"] == 3 && pObj["rating"] == 0.0),
                  onWriteReviewPressed: () {},
                );
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAmountRow("Amount:",
                      "\$${(order["totalPrice"] ?? 0).toStringAsFixed(2)}"),
                  _buildAmountRow("Delivery Cost:",
                      "+ \$${(order["deliverPrice"] ?? 0).toStringAsFixed(2)}"),
                  _buildAmountRow("Discount:",
                      "- \$${(order["discountPrice"] ?? 0).toStringAsFixed(2)}",
                      isDiscount: true),
                  const Divider(color: Colors.black12, thickness: 1),
                  _buildAmountRow("Total:",
                      "\$${(order["userPayPrice"] ?? 0).toStringAsFixed(2)}",
                      isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
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

  // Dummy methods — you can adjust based on your logic
  String getPaymentStatus(Map<String, dynamic> order) =>
      order["isPaid"] == true ? "Paid" : "Unpaid";

  Color getPaymentStatusColor(Map<String, dynamic> order) =>
      order["isPaid"] == true ? Colors.green : Colors.red;

  String getOrderStatus(Map<String, dynamic> order) {
    switch (order["orderStatus"]) {
      case 0:
        return "Pending";
      case 1:
        return "Accepted";
      case 2:
        return "Shipped";
      case 3:
        return "Delivered";
      case 4:
        return "Cancelled";
      default:
        return "Unknown";
    }
  }

  Color getOrderStatusColor(Map<String, dynamic> order) {
    switch (order["orderStatus"]) {
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String getDeliverType(Map<String, dynamic> order) =>
      (order["deliverType"] ?? "Standard").toString();

  String getPaymentType(Map<String, dynamic> order) =>
      (order["paymentType"] ?? "COD").toString();
}
