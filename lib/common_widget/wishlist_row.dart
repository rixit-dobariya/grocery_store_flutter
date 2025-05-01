import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';

class WishlistRow extends StatelessWidget {
  final Map product;
  final VoidCallback onPressed;
  final VoidCallback onViewDetails;
  final VoidCallback onAddToCart;
  final bool isDeleteLoading;
  final bool isAddToCartLoading;

  const WishlistRow({
    super.key,
    required this.product,
    required this.onPressed,
    required this.onViewDetails,
    required this.onAddToCart,
    required this.isDeleteLoading,
    required this.isAddToCartLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product["productImage"],
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product["productName"],
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product["description"] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "₹${product["salePrice"]}",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: isAddToCartLoading ? null : onAddToCart,
                    icon: isAddToCartLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.add_shopping_cart, size: 18),
                    label:
                        Text(isAddToCartLoading ? "Adding..." : "Add to Cart"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                isDeleteLoading
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: onPressed,
                      ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: TColor.primaryText),
                  onPressed: onViewDetails,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
