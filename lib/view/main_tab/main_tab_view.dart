import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/view/account/account_view.dart';
import 'package:grocery_store_flutter/view/explore/explore_view.dart';
import 'package:grocery_store_flutter/view/home/home_view.dart';
import 'package:grocery_store_flutter/view/my_cart/my_cart_view.dart';
import 'package:grocery_store_flutter/view/wishlist/wishlist_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this);
    controller?.addListener(() {
      selectedTab = controller?.index ?? 0;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: [
          const HomeView(),
          const ExploreView(),
          const MyCartView(),
          const WishlistView(),
          const AccountView(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, -2),
              blurRadius: 3,
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: TabBar(
            controller: controller,
            indicatorColor: Colors.transparent,
            indicatorWeight: 1,
            labelColor: TColor.primary,
            labelStyle: TextStyle(
              color: TColor.primary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelColor: TColor.primaryText,
            unselectedLabelStyle: TextStyle(
              color: TColor.primaryText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(
                text: "Shop",
                // icon: Image.asset(
                //   "assets/img/store_tab.png",
                //   height: 25,
                //   width: 25,
                // ),
                icon: Icon(Icons.storefront),
              ),
              Tab(
                text: "Explore",
                // icon: Image.asset(
                //   "assets/img/explore_tab.png",
                //   height: 25,
                //   width: 25,
                // ),
                icon: Icon(Icons.manage_search_rounded),
              ),
              Tab(
                text: "Cart",
                // icon: Image.asset(
                //   "assets/img/cart_tab.png",
                //   height: 25,
                //   width: 25,
                // ),
                icon: Icon(Icons.shopping_cart_rounded),
              ),
              Tab(
                text: "Wishlist",
                // icon: Image.asset(
                //   "assets/img/fav_tab.png",
                //   height: 25,
                //   width: 25,
                // ),
                icon: Icon(Icons.favorite_outline_rounded),
              ),
              Tab(
                text: "Account",
                // icon: Image.asset(
                //   "assets/img/account_tab.png",
                //   height: 25,
                //   width: 25,
                // ),
                icon: Icon(Icons.account_circle_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
