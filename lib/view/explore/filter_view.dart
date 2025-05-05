import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';
import 'package:grocery_store_flutter/controllers/category_controller.dart';
import 'package:grocery_store_flutter/controllers/filter_controller.dart';

class FilterView extends StatelessWidget {
  final FilterController filterController = Get.find<FilterController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    categoryController.fetchCategories(); // Load categories once

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Filters",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: Obx(() {
        return categoryController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xffF2F3F2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Categories",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 10),
                            ...categoryController.categories.map((cat) {
                              return Obx(() => CheckboxListTile(
                                    value: filterController.selectedCategories
                                        .contains(cat.id),
                                    onChanged: (_) =>
                                        filterController.toggleCategory(cat.id),
                                    title: Text(cat.name,
                                        style: TextStyle(
                                            color: TColor.primaryText)),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ));
                            }).toList(),
                            const SizedBox(height: 20),
                            const Text("Price Range",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 10),
                            Obx(() {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "₹${filterController.minPrice.value.toInt()} - ₹${filterController.maxPrice.value.toInt()}",
                                      style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 16)),
                                  RangeSlider(
                                    values: RangeValues(
                                      filterController.minPrice.value,
                                      filterController.maxPrice.value,
                                    ),
                                    min: 0,
                                    max: 1000,
                                    divisions: 100,
                                    onChanged: (RangeValues values) {
                                      filterController.updatePriceRange(
                                          values.start, values.end);
                                    },
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    RoundButton(
                      title: "Apply",
                      onPressed: () {
                        filterController
                            .applyFilters(filterController.allProducts);
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        filterController.clearFilters();
                      },
                      child: const Text("Clear Filters"),
                    )
                  ],
                ),
              );
      }),
    );
  }
}
