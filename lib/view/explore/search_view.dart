import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common_widget/product_cell.dart';
import 'package:grocery_store_flutter/view/explore/filter_view.dart';
import '../../common/color_extension.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController txtSearch = TextEditingController();

  List searchArr = [
    {
      "name": "Egg Chicken Red",
      "icon": "assets/img/egg_chicken_red.png",
      "qty": "4",
      "unit": "pcs, Price",
      "price": "₹171.13" // Converted from $1.99
    },
    {
      "name": "Egg Chicken White",
      "icon": "assets/img/egg_chicken_white.png",
      "qty": "2",
      "unit": "pcs, Price",
      "price": "₹128.12" // Converted from $1.49
    },
    {
      "name": "Egg Pasta",
      "icon": "assets/img/egg_pasta.png",
      "qty": "1",
      "unit": "Kg, Price",
      "price": "₹343.13" // Converted from $3.99
    },
    {
      "name": "Egg Noodles",
      "icon": "assets/img/egg_noodles.png",
      "qty": "1",
      "unit": "Kg, Price",
      "price": "₹558.13" // Converted from $6.49
    },
    {
      "name": "Mayonnaise Eggless",
      "icon": "assets/img/mayinnars_eggless.png",
      "qty": "325",
      "unit": "mL, Price",
      "price": "₹257.13" // Converted from $2.99
    },
    {
      "name": "Egg Noodles",
      "icon": "assets/img/egg_noodies_new.png",
      "qty": "2",
      "unit": "Kg, Price",
      "price": "₹816.13" // Converted from $9.49
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
            size: 30,
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
              size: 27,
              color: Colors.black,
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xffF2F3F2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: txtSearch,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: 20,
                ),
                onPressed: () {
                  txtSearch.text = "";
                  setState(() {});
                  FocusScope.of(context).requestFocus(FocusNode());
                },
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
        itemCount: searchArr.length,
        itemBuilder: (context, index) {
          var pObj = searchArr[index] as Map? ?? {};
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
