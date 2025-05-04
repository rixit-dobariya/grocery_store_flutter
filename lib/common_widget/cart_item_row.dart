import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';

class CartItemRow extends StatelessWidget {
  final Map pObj;
  final VoidCallback onRemove;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final bool isUpdating;
  final bool isDeleting;

  const CartItemRow({
    super.key,
    required this.pObj,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
    this.isUpdating = false,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final product = pObj['productId'];
    final int quantity = pObj['quantity'];
    final int salePrice = product['salePrice'] ?? 0;
    final int discount = product['discount'] ?? 0;

    final priceAfterDiscount = salePrice - salePrice * discount / 100;
    final totalPrice = priceAfterDiscount * quantity;

    return Container(
      height: 160,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                "${product['productImage']}",
                height: 80,
                width: 65,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['productName'],
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        isDeleting
                            ? const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : IconButton(
                                onPressed: onRemove,
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: TColor.secondaryText,
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (isUpdating)
                          const SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          )
                        else ...[
                          _quantityButton(
                            icon: Icons.remove,
                            onPressed: quantity > 1 ? onDecrease : null,
                            color: TColor.secondaryText,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "$quantity",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 20),
                          _quantityButton(
                            icon: Icons.add,
                            onPressed: onIncrease,
                            color: TColor.primary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹$priceAfterDiscount",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "x $quantity",
                          style: TextStyle(
                            color: TColor.primary.withOpacity(0.7),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "₹$totalPrice",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: TColor.placeholder.withOpacity(0.5),
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 20,
        onPressed: onPressed,
        icon: Icon(icon, color: color),
      ),
    );
  }
}
