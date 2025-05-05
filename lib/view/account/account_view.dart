import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_store_flutter/view/login/sign_in_view.dart';
import 'package:grocery_store_flutter/view/account/about_view.dart';
import 'package:grocery_store_flutter/view/account/contact_view.dart';
import 'package:grocery_store_flutter/view/account/promo_code_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/account_row.dart';
import 'address_list_view.dart';
import 'my_detail_view.dart';
import 'my_order_view.dart';
// import 'notification_view.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  // Static user details
  final String userName = "Code For Any";
  final String userEmail = "codeforany@gmail.com";

  void logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('userId');
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
    );
    Get.offAll(() => const SignInView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Image.asset(
                        "assets/img/u1.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                userName,
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.edit,
                                color: TColor.primary,
                                size: 18,
                              )
                            ],
                          ),
                          Text(
                            userEmail,
                            style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(color: Colors.black26, height: 1),
              AccountRow(
                title: "My Orders",
                icon: "assets/img/a_order.png",
                onPressed: () {
                  Get.to(() => const MyOrdersView());
                },
              ),
              AccountRow(
                title: "My Details",
                icon: "assets/img/a_my_detail.png",
                onPressed: () {
                  Get.to(() => const MyDetailView());
                },
              ),
              AccountRow(
                title: "Delivery Address",
                icon: "assets/img/a_delivery_address.png",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddressListView()),
                  );
                },
              ),
              AccountRow(
                title: "Promo Code",
                icon: "assets/img/a_promocode.png",
                onPressed: () {
                  Get.to(PromoCodeView());
                },
              ),
              AccountRow(
                title: "Contact",
                icon: "assets/img/contact.png",
                onPressed: () {
                  Get.to(ContactView());
                },
              ),
              AccountRow(
                title: "About",
                icon: "assets/img/a_about.png",
                onPressed: () {
                  Get.to(AboutView());
                },
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: logout,
                      height: 60,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19)),
                      minWidth: double.maxFinite,
                      elevation: 0.1,
                      color: const Color(0xffF2F3F2),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Log Out",
                                style: TextStyle(
                                  color: TColor.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Image.asset(
                              "assets/img/logout.png",
                              width: 20,
                              height: 20,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
