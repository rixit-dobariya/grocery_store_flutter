import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';

class WishlistRow extends StatelessWidget {
  final Map pObj;
  final VoidCallback onPressed;
  const WishlistRow({
    super.key,
    required this.pObj,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Image.asset(
                  pObj["icon"],
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pObj["name"],
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${pObj["qty"]} ${pObj["unit"]}",
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  pObj["price"],
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
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
