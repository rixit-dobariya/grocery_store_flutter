import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';

class ProductCell extends StatelessWidget {
  final Map pObj;
  final VoidCallback onPressed;
  final VoidCallback onCart;
  final double margin;
  final double weight;
  final bool isLoading;

  const ProductCell({
    super.key,
    required this.pObj,
    required this.onPressed,
    required this.onCart,
    this.weight = 180,
    this.margin = 8,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: weight,
        margin: EdgeInsets.symmetric(horizontal: margin),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border.all(color: TColor.placeholder.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                pObj["productImage"] ?? '',
                height: 100,
                width: 80,
                fit: BoxFit.contain,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(Icons.error, color: Colors.red, size: 40),
                ),
              ),
            ),
            const Spacer(),
            Text(
              pObj["productName"] ?? '',
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                RatingBarIndicator(
                  rating: double.tryParse(
                          pObj["averageRating"]?.toString() ?? "0") ??
                      0.0,
                  itemBuilder: (context, index) =>
                      Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 16.0,
                  direction: Axis.horizontal,
                ),
                const SizedBox(width: 4),
                Text(
                  "(${pObj["totalReviews"] ?? 0})",
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${pObj["salePrice"] - pObj["salePrice"] * pObj["discount"] / 100}",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : InkWell(
                        onTap: onCart,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: TColor.primary,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.add, size: 28, color: Colors.white),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
