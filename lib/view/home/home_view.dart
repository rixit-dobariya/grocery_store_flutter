import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common_widget/category_cell.dart';
import 'package:grocery_store_flutter/common_widget/product_cell.dart';
import 'package:grocery_store_flutter/common_widget/section_view.dart';
import 'package:grocery_store_flutter/view/home/product_details_view.dart';

import '../../common/color_extension.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtSearch = TextEditingController();
  bool isVisible = false;

  List exclusiveOfferArr = [
    {
      "name": "Organic Bananas",
      "icon": "assets/img/banana.png",
      "qty": "7",
      "unit": "pcs, Prices",
      "price": "₹29.00"
    },
    {
      "name": "Red Apple",
      "icon": "assets/img/bell_pepper_red.png",
      "qty": "1",
      "unit": "Kg, Prices",
      "price": "₹59.00"
    },
  ];
  List bestSellingArr = [
    {
      "name": "Bell Pepper Red",
      "icon": "assets/img/bell_pepper_red.png",
      "qty": "1",
      "unit": "Kg, Prices",
      "price": "99.00"
    },
    {
      "name": "Ginger",
      "icon": "assets/img/ginger.png",
      "qty": "250",
      "unit": "gm, Prices",
      "price": "129.00"
    },
  ];
  List groceriesArr = [
    {
      "name": "Pulses",
      "icon": "assets/img/pulses.png",
      "color": Color(0xffF8A44C),
    },
    {
      "name": "Rice",
      "icon": "assets/img/rice.png",
      "color": Color(0xff53B175),
    },
  ];
  List listArr = [
    {
      "name": "Beef Bone",
      "icon": "assets/img/beef_bone.png",
      "qty": "1",
      "unit": "Kg, Prices",
      "price": "₹499.00"
    },
    {
      "name": "Broiler Chicken",
      "icon": "assets/img/broiler_chicken.png",
      "qty": "1",
      "unit": "Kg, Prices",
      "price": "₹499.00"
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: media.height * 0.025,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(
                  'assets/img/color_logo.png',
                  fit: BoxFit.contain,
                  width: media.width * 0.1,
                  height: media.width * 0.1,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xffF2F3F2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: txtSearch,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Search",
                      hintStyle: TextStyle(
                          color: TColor.placeholder,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.maxFinite,
                  height: 115,
                  decoration: BoxDecoration(
                    color: const Color(0XFFF2F3F2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/img/banner_top.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SectionView(
                title: "Exclusive Offers",
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                onPressed: () {},
              ),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: exclusiveOfferArr.length,
                  itemBuilder: (context, index) {
                    var pObj = exclusiveOfferArr[index] as Map? ?? {};
                    return ProductCell(
                      pObj: pObj,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetailsView()),
                        );
                      },
                      onCart: () {},
                    );
                  },
                ),
              ),
              SectionView(
                title: "Best Selling",
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                onPressed: () {},
              ),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: bestSellingArr.length,
                  itemBuilder: (context, index) {
                    var pObj = bestSellingArr[index] as Map? ?? {};
                    return ProductCell(
                      pObj: pObj,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetailsView()),
                        );
                      },
                      onCart: () {},
                    );
                  },
                ),
              ),
              SectionView(
                title: "Groceries",
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                onPressed: () {},
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: groceriesArr.length,
                  itemBuilder: (context, index) {
                    var pObj = groceriesArr[index] as Map? ?? {};
                    return CategoryCell(
                      pObj: pObj,
                      onPressed: () {},
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: listArr.length,
                  itemBuilder: (context, index) {
                    var pObj = listArr[index] as Map? ?? {};
                    return ProductCell(
                      pObj: pObj,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetailsView()),
                        );
                      },
                      onCart: () {},
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
