import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/filter_row.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  List selectArr = [];
  List filterCatArr = [
    {
      "id": "1",
      "name": "Eggs",
    },
    {
      "id": "2",
      "name": "Noodles & Pasta",
    },
    {
      "id": "3",
      "name": "Chips & Crisps",
    },
    {
      "id": "4",
      "name": "Fast Food",
    }
  ];
  List filterBrandArr = [
    {
      "id": "1",
      "name": "Individual Collection",
    },
    {
      "id": "2",
      "name": "Cocola",
    },
    {
      "id": "3",
      "name": "Ifad",
    },
    {
      "id": "4",
      "name": "Kazi Farmss",
    }
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
            Icons.close_rounded,
            size: 30,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Filters",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Color(0xffF2F3F2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Column(
                      children: filterCatArr.map(
                        (fObj) {
                          return FilterRow(
                            fObj: fObj,
                            isSelected: selectArr.contains(fObj),
                            onPressed: () {
                              if (selectArr.contains(fObj)) {
                                selectArr.remove(fObj);
                              } else {
                                selectArr.add(fObj);
                              }
                              setState(() {});
                            },
                          );
                        },
                      ).toList(),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Brand",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Column(
                      children: filterBrandArr.map(
                        (fObj) {
                          return FilterRow(
                            fObj: fObj,
                            isSelected: selectArr.contains(fObj),
                            onPressed: () {
                              if (selectArr.contains(fObj)) {
                                selectArr.remove(fObj);
                              } else {
                                selectArr.add(fObj);
                              }
                              setState(() {});
                            },
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ),
            RoundButton(title: "Apply", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
