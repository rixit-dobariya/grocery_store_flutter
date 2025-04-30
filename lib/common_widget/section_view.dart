import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';

class SectionView extends StatelessWidget {
  final String title;
  final bool isShowAllButton;
  final VoidCallback onPressed;
  final EdgeInsets? padding;

  const SectionView({
    super.key,
    required this.title,
    this.isShowAllButton = true,
    this.padding,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isShowAllButton)
            TextButton(
              onPressed: onPressed,
              child: Text(
                "See All",
                style: TextStyle(
                  color: TColor.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
