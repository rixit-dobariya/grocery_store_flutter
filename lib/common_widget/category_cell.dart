import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/models/category_model.dart';

class CategoryCell extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onPressed;

  const CategoryCell({
    super.key,
    required this.category,
    required this.onPressed,
  });

  // Convert hex color to Color
  Color hexToColor(String hexString) {
    Color c = Color(int.parse(hexString.replaceFirst('#', 'ff'),
        radix: 16)); // Add full opacity
    return c;
  }

  // Check if the image URL is a network image
  bool isNetworkImage(String url) {
    return url.startsWith('http') || url.startsWith('https');
  }

  @override
  Widget build(BuildContext context) {
    // Get the background color
    final backgroundColor = category.color.isNotEmpty
        ? hexToColor(category.color)
            .withOpacity(0.3) // Apply some opacity to the background color
        : TColor.primary; // Fallback to primary color if the color is empty

    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 250,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            SizedBox(
              height: 70,
              width: 70,
              child: isNetworkImage(category.image)
                  ? Image.network(
                      category.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    )
                  : Image.asset(
                      category.image,
                      fit: BoxFit.contain,
                    ),
            ),
            const SizedBox(width: 15),

            // Text
            Expanded(
              child: Text(
                category.name,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
