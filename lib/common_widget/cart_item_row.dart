import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';

class CartItemRow extends StatelessWidget {
  final Map pObj;
  const CartItemRow({
    super.key,
    required this.pObj,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                pObj["icon"],
                height: 80,
                width: 65,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
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
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.close_rounded,
                            color: TColor.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${pObj["unit"]}",
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: TColor.placeholder.withOpacity(0.5),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.remove,
                              size: 25,
                              color: TColor.secondaryText,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          pObj["qty"].toString(),
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: TColor.placeholder.withOpacity(0.5),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add,
                              size: 25,
                              color: TColor.primary,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          pObj["price"],
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
