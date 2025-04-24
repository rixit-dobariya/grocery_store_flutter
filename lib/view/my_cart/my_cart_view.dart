import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/cart_item_row.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';
import 'package:grocery_store_flutter/view/my_cart/checkout_view.dart';

class MyCartView extends StatefulWidget {
  const MyCartView({super.key});

  @override
  State<MyCartView> createState() => _MyCartViewState();
}

class _MyCartViewState extends State<MyCartView> {
  List cartArr = [
    {
      "name": "Egg Chicken Red",
      "icon": "assets/img/egg_chicken_red.png",
      "qty": "4",
      "unit": "pcs, Price",
      "price": "₹171.14" // Converted from $1.99
    },
    {
      "name": "Egg Chicken White",
      "icon": "assets/img/egg_chicken_white.png",
      "qty": "2",
      "unit": "pcs, Price",
      "price": "₹128.14" // Converted from $1.49
    },
    {
      "name": "Egg Pasta",
      "icon": "assets/img/egg_pasta.png",
      "qty": "1",
      "unit": "Kg, Price",
      "price": "₹343.14" // Converted from $3.99
    },
    {
      "name": "Egg Noodles",
      "icon": "assets/img/egg_noodles.png",
      "qty": "1",
      "unit": "Kg, Price",
      "price": "₹558.14" // Converted from $6.49
    },
    {
      "name": "Mayonnaise Eggless",
      "icon": "assets/img/mayinnars_eggless.png",
      "qty": "325",
      "unit": "mL, Price",
      "price": "₹257.14" // Converted from $2.99
    },
    {
      "name": "Egg Noodles",
      "icon": "assets/img/egg_noodies_new.png",
      "qty": "2",
      "unit": "Kg, Price",
      "price": "₹816.14" // Converted from $9.49
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "My Cart",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: cartArr.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.black26,
            ),
            itemBuilder: (context, index) {
              var pObj = cartArr[index] as Map? ?? {};
              return CartItemRow(pObj: pObj);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    showCheckout();
                  },
                  height: 60,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19)),
                  minWidth: double.maxFinite,
                  elevation: 0.1,
                  color: TColor.primary,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Go to Checkout",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Text(
                          "₹500",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showCheckout() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return CheckoutView();
      },
    );
  }
}
