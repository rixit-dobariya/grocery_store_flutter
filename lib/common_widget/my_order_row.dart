import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class MyOrderRow extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final VoidCallback onTap;

  const MyOrderRow({super.key, required this.orderData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final address = orderData['delAddressId'];

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID & Date
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Order No: #${orderData['_id'] ?? ''}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: TColor.primaryText,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getOrderStatusColor(orderData['orderStatus']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    orderData['orderStatus'] ?? "",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Text(
              formatDate(orderData['createdAt']),
              style: TextStyle(color: TColor.secondaryText, fontSize: 12),
            ),
            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildOrderRow("Total:",
                          "₹${orderData['total']?['\$numberDecimal'] ?? '0'}"),
                      buildOrderRow("Shipping:",
                          "₹${orderData['shippingCharge']?['\$numberDecimal'] ?? '0'}"),
                      buildOrderRow(
                          "Payment Mode:", orderData['paymentMode'] ?? ""),
                      buildOrderRow(
                        "Payment Status:",
                        orderData['paymentStatus'] ?? "",
                        statusColor:
                            getPaymentStatusColor(orderData['paymentStatus']),
                      ),
                      if (address != null)
                        buildOrderRow(
                          "Delivery Address:",
                          "${address['fullName']}, ${address['address']}, ${address['city']}, ${address['state']}, ${address['pincode']}, Ph: ${address['phone']}",
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: statusColor ?? TColor.secondaryText,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getOrderStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "shipped":
        return Colors.blue;
      case "delivered":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getPaymentStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "failed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatDate(String? isoDate) {
    if (isoDate == null) return "";
    final dateTime = DateTime.tryParse(isoDate);
    if (dateTime == null) return "";
    return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
  }
}
