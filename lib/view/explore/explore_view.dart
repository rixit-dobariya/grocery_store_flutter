import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common_widget/explore_cell.dart';
import 'package:grocery_store_flutter/controllers/category_controller.dart';
import 'package:grocery_store_flutter/models/category_model.dart';
import 'package:grocery_store_flutter/view/explore/explore_detail_view.dart';
import 'package:grocery_store_flutter/view/explore/search_view.dart';
import '../../common/color_extension.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    categoryController.fetchCategories();
  }

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
                  color: const Color(0xffF2F3F2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(13),
                      child: Icon(Icons.search_rounded, size: 20),
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
          const SizedBox(height: 15),
          Expanded(
            child: Obx(() {
              if (categoryController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: categoryController.categories.length,
                itemBuilder: (context, index) {
                  final category = categoryController.categories[index];
                  return ExploreCell(
                    category: category,
                    onPressed: () {
                      Get.to(() => ExploreDetailsView(category: category));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
