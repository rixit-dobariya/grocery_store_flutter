import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';

class CategoryCell extends StatelessWidget {
  final Map pObj;
  final VoidCallback onPressed;
  const CategoryCell({
    super.key,
    required this.pObj,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 250,
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: (pObj["color"] as Color? ?? TColor.primary).withOpacity(0.3),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  pObj["icon"],
                  height: 70,
                  width: 70,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Text(
                    pObj["name"],
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
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
