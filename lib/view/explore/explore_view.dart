import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common_widget/explore_cell.dart';
import 'package:grocery_store_flutter/view/explore/explore_detail_view.dart';
import 'package:grocery_store_flutter/view/explore/search_view.dart';
import '../../common/color_extension.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});
  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  TextEditingController txtSearch = TextEditingController();
  bool isVisible = false;

  List findProductArr = [
    {
      "name": "Fresh Fruits & Vegetables",
      "icon": "assets/img/frash_fruits.png",
      "color": const Color(0xFF5B1B75),
    },
    {
      "name": "Cooking Oil & Ghee",
      "icon": "assets/img/cooking_oil.png",
      "color": const Color(0xFFB4A04C),
    },
    {
      "name": "Meat & Fish",
      "icon": "assets/img/meat_fish.png",
      "color": const Color(0xFF7FA359),
    },
    {
      "name": "Bakery & Snacks",
      "icon": "assets/img/bakery_snacks.png",
      "color": const Color(0xFFD3B0E0),
    },
    {
      "name": "Dairy & Eggs",
      "icon": "assets/img/dairy_eggs.png",
      "color": const Color(0xFFDED5E9),
    },
    {
      "name": "Beverages",
      "icon": "assets/img/beverages.png",
      "color": const Color(0xFFB7DFF5),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Find Products",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchView()),
                );
              },
              child: Container(
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffF2F3F2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(13),
                      child: Icon(
                        Icons.search_rounded,
                        size: 20,
                      ),
                    ),
                    Text(
                      "Search store",
                      style: TextStyle(
                        color: TColor.placeholder,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 20,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.95,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: findProductArr.length,
              itemBuilder: (context, index) {
                var eObj = findProductArr[index] as Map? ?? {};
                return ExploreCell(
                  pObj: eObj,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExploreDetailsView(eObj: eObj),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
