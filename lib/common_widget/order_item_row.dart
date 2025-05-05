import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

class OrderItemRow extends StatelessWidget {
  final bool showReviewButton;
  final String imageUrl;
  final String name;
  final int qty;
  final double totalPrice;
  final VoidCallback onWriteReviewPressed;

  const OrderItemRow({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.qty,
    required this.totalPrice,
    this.showReviewButton = false,
    required this.onWriteReviewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
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
              Image.network(
                imageUrl,
                width: 80,
                height: 65,
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
                    Text(
                      name,
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Quantity: $qty",
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "\₹${totalPrice.toStringAsFixed(2)}",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (showReviewButton)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: RoundButton(
                title: "Write A Review",
                onPressed: onWriteReviewPressed,
              ),
            ),
        ],
      ),
    );
  }
}
