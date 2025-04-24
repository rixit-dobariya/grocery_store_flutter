import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class MyOrderRow extends StatelessWidget {
  final Map<String, dynamic> orderData; // Now directly using a Map
  final VoidCallback onTap;

  const MyOrderRow({super.key, required this.orderData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                Text(
                  "Order No: #",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                Expanded(
                  child: Text(
                    orderData['orderId']?.toString() ?? "",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  getOrderStatus(orderData),
                  style: TextStyle(
                      color: getOrderStatusColor(orderData),
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
            Text(
              orderData['createdDate'] ?? "",
              style: TextStyle(color: TColor.secondaryText, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((orderData['images']?.length ?? 0) > 0)
                  Image.network(
                    "",
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildOrderRow("Items: ", orderData['names'] ?? ""),
                      buildOrderRow(
                          "Delivery Type: ", getDeliverType(orderData)),
                      buildOrderRow(
                          "Payment Type: ", getPaymentType(orderData)),
                      buildOrderRow(
                        "Payment Status: ",
                        getPaymentStatus(orderData),
                        statusColor: getPaymentStatusColor(orderData),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderRow(String label, String value, {Color? statusColor}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w700),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                color: statusColor ?? TColor.secondaryText,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  String getOrderStatus(Map<String, dynamic> orderData) {
    switch (orderData['orderStatus']) {
      case 1:
        return "Placed";
      case 2:
        return "Accepted";
      case 3:
        return "Delivered";
      case 4:
        return "Cancel";
      case 5:
        return "Declined";
      default:
        return "";
    }
  }

  String getDeliverType(Map<String, dynamic> orderData) {
    switch (orderData['deliverType']) {
      case 1:
        return "Delivery";
      case 2:
        return "Collection";
      default:
        return "";
    }
  }

  String getPaymentType(Map<String, dynamic> orderData) {
    switch (orderData['paymentType']) {
      case 1:
        return "Cash On Delivery";
      case 2:
        return "Online Card Payment";
      default:
        return "";
    }
  }

  String getPaymentStatus(Map<String, dynamic> orderData) {
    if (orderData['paymentType'] == 1) {
      return "COD";
    }
    switch (orderData['paymentStatus']) {
      case 1:
        return "Processing";
      case 2:
        return "Success";
      case 3:
        return "Fail";
      case 4:
        return "Refunded";
      default:
        return "";
    }
  }

  Color getPaymentStatusColor(Map<String, dynamic> orderData) {
    if (orderData['paymentType'] == 1) {
      return Colors.orange;
    }
    switch (orderData['paymentStatus']) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  Color getOrderStatusColor(Map<String, dynamic> orderData) {
    switch (orderData['orderStatus']) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      case 5:
        return Colors.red;
      default:
        return TColor.primary;
    }
  }
}
