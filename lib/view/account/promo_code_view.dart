import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../common/color_extension.dart';
import '../../common/app_constants.dart'; // Assumes AppConstants is defined here

class PromoCodeView extends StatefulWidget {
  final Function(Map<String, dynamic> pObj)? didSelect;

  const PromoCodeView({super.key, this.didSelect});

  @override
  State<PromoCodeView> createState() => _PromoCodeViewState();
}

class _PromoCodeViewState extends State<PromoCodeView> {
  List<Map<String, dynamic>> promoCodes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPromoCodes();
  }

  Future<void> fetchPromoCodes() async {
    try {
      var url = Uri.parse('${AppConstants.baseUrl}/offers');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        setState(() {
          promoCodes = data.map<Map<String, dynamic>>((item) {
            return {
              "id": item["_id"],
              "name": item["offerCode"],
              "discount": item["discount"],
              "description": item["offerDescription"],
              "activeStatus": item["activeStatus"],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load promo codes");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching promo codes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset("assets/img/back.png", width: 20, height: 20),
        ),
        centerTitle: true,
        title: Text(
          "Promo Code",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : promoCodes.isEmpty
              ? Center(
                  child: Text(
                    "No Promo Codes Available",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  itemCount: promoCodes.length,
                  itemBuilder: (context, index) {
                    final pObj = promoCodes[index];
                    return GestureDetector(
                      onTap: () {
                        if (widget.didSelect != null) {
                          widget.didSelect!(pObj);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pObj["name"] ?? "",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: TColor.primaryText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              pObj["description"] ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                color: TColor.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            if (pObj["discount"] != null &&
                                pObj["discount"] > 0)
                              Text(
                                "${pObj["discount"]}% OFF",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                ),
    );
  }
}
