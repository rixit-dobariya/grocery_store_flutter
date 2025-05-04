import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/models/category_model.dart';

class ExploreCell extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onPressed;

  const ExploreCell({
    super.key,
    required this.category,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    try {
      color = Color(int.parse(category.color.replaceFirst('#', '0xFF')));
    } catch (_) {
      color = TColor.primary; // fallback color
    }

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1),
          color: color.withOpacity(0.25),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              // assuming `image` is a URL
              category.image,
              height: 90,
              width: 90,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
            ),
            const Spacer(),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
