import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';

class CheckoutRow extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onPressed;
  final bool isButton;
  const CheckoutRow({
    super.key,
    required this.title,
    required this.value,
    required this.onPressed,
    this.isButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.end,
                    value,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                if (isButton)
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 30,
                    color: TColor.primaryText,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
