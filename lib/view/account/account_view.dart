import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common/app_constants.dart';
import 'package:grocery_store_flutter/controllers/google_sign_in_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_store_flutter/view/login/sign_in_view.dart';
import 'package:grocery_store_flutter/view/account/about_view.dart';
import 'package:grocery_store_flutter/view/account/contact_view.dart';
import 'package:grocery_store_flutter/view/account/promo_code_view.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  String fullName = '';
  String email = '';
  String profilePicture = '';
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        Get.snackbar("Error", "User ID not found");
        return;
      }

      final response =
          await http.get(Uri.parse("${AppConstants.baseUrl}/users/$userId"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            fullName = "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}";
            email = data['email'] ?? '';
            profilePicture = data['profilePicture'] ?? '';
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
        }
        Get.snackbar("Error", "Failed to load user data");
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      Get.snackbar("Error", "Error: $e");
    }
  }

  Future<ImageProvider> getProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authType = prefs.getString(
        'authType'); // Assuming 'authType' is stored in shared preferences

    // If authType is Google, fetch the photo from Firebase
    if (authType == 'Google') {
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is logged in and has a photo URL
      if (user != null && user.photoURL != null) {
        return NetworkImage(user.photoURL!);
      }
    }
    if (profilePicture.isEmpty) {
      return const AssetImage("assets/img/default_profile.png");
    } else {
      return NetworkImage(profilePicture);
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    final authType = prefs.getString('authType');

    if (authType == 'Google') {
      // Use Get.find if you're using Get.put() for controller, otherwise
      final googleSignInController = Get.put(GoogleSignInController());
      await googleSignInController.signOut();
    }

    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('authType');

    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );

    Get.offAll(() => const SignInView());
  }

  Future<String> getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authType =
        prefs.getString('authType'); // Assuming 'authType' is stored

    // If authType is Google, fetch the full name from Firebase
    if (authType == 'Google') {
      User? user = FirebaseAuth.instance.currentUser;

      // If the user is logged in, fetch the full name
      if (user != null && user.displayName != null) {
        return user.displayName!;
      }
    }

    // If no Google auth or no full name, return an empty string or fallback value
    return fullName; // You can replace this with the value from shared preferences or your data
  }

  Future<String?> getAuthType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authType');
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
                      child: FutureBuilder<ImageProvider>(
                        future: getProfileImage(), // Fetch image asynchronously
                        builder: (BuildContext context,
                            AsyncSnapshot<ImageProvider> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show loading while waiting
                          } else if (snapshot.hasError) {
                            return const Icon(
                                Icons.error); // Show error if there's any issue
                          } else if (snapshot.hasData) {
                            return CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  snapshot.data, // Use the fetched image
                            );
                          } else {
                            return const Icon(
                                Icons.account_circle); // Default icon
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              FutureBuilder<String>(
                                future:
                                    getFullName(), // Call the async function to get full name
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                      "Loading...",
                                      style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ); // Show loading while waiting
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      "Error loading name",
                                      style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ); // Show error message if any
                                  } else if (snapshot.hasData) {
                                    return Text(
                                      snapshot
                                          .data!, // Display the fetched full name
                                      style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      "No Name Available", // Default if no data is available
                                      style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(width: 8),
                              FutureBuilder<String?>(
                                future:
                                    getAuthType(), // async function to get authType
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox(); // Or a loading indicator if you prefer
                                  }

                                  final authType = snapshot.data;

                                  if (!_isLoading && authType != 'Google') {
                                    return IconButton(
                                      onPressed: () {
                                        Get.to(() => MyDetailView());
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: TColor.primary,
                                        size: 18,
                                      ),
                                    );
                                  } else {
                                    return const SizedBox(); // Return empty widget otherwise
                                  }
                                },
                              ),
                            ],
                          ),
                          Text(
                            _isLoading ? "Loading..." : email,
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
              FutureBuilder<String?>(
                future: getAuthType(), // Fetch authType asynchronously
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(); // Placeholder while loading
                  }

                  final authType = snapshot.data;

                  // Show IconButton only if not loading and authType is NOT Google
                  if (!_isLoading && authType != 'Google') {
                    return AccountRow(
                      title: "My Details",
                      icon: "assets/img/a_my_detail.png",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyDetailView()),
                        );
                      },
                    );
                  } else {
                    return const SizedBox(); // Empty space if condition not met
                  }
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
