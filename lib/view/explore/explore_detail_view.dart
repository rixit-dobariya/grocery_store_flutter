import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common_widget/product_cell.dart';
import 'package:grocery_store_flutter/view/explore/filter_view.dart';
import '../../common/color_extension.dart';

class ExploreDetailsView extends StatefulWidget {
  final Map eObj;
  const ExploreDetailsView({super.key, required this.eObj});
  @override
  State<ExploreDetailsView> createState() => _ExploreDetailsViewState();
}

class _ExploreDetailsViewState extends State<ExploreDetailsView> {
  List listArr = [
    {
      "name": "Diet Coke",
      "icon": "assets/img/diet_coke.png",
      "qty": "355",
      "unit": "mL, Price",
      "price": "₹171.43"
    },
    {
      "name": "Sprite Can",
      "icon": "assets/img/sprite_can.png",
      "qty": "325",
      "unit": "mL, Price",
      "price": "₹128.56"
    },
    {
      "name": "Apple & Grape Juice",
      "icon": "assets/img/juice_apple_grape.png",
      "qty": "2",
      "unit": "L, Price",
      "price": "₹1,375.84"
    },
    {
      "name": "Orange Juice",
      "icon": "assets/img/orenge_juice.png",
      "qty": "2",
      "unit": "L, Price",
      "price": "₹1,332.65" // Converted from $15.49
    },
    {
      "name": "Coca Cola Can",
      "icon": "assets/img/cocacola_can.png",
      "qty": "325",
      "unit": "mL, Price",
      "price": "₹428.19" // Converted from $4.99
    },
    {
      "name": "Pepsi Can",
      "icon": "assets/img/pepsi_can.png",
      "qty": "325",
      "unit": "mL, Price",
      "price": "₹386.13" // Converted from $4.49
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left_rounded,
            size: 25,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FilterView()),
              );
            },
            icon: Icon(
              Icons.filter_alt_rounded,
              size: 25,
              color: Colors.black,
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.eObj["name"].toString(),
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: listArr.length,
        itemBuilder: (context, index) {
          var pObj = listArr[index] as Map? ?? {};
          return ProductCell(
            pObj: pObj,
            onPressed: () {},
            onCart: () {},
            margin: 0,
            weight: double.maxFinite,
          );
        },
      ),
    );
  }
}
