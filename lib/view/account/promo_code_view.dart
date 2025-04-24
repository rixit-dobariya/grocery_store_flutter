import 'package:flutter/material.dart';
import '../../common/color_extension.dart';

class PromoCodeView extends StatelessWidget {
  final Function(Map<String, dynamic> pObj)? didSelect;

  const PromoCodeView({super.key, this.didSelect});

  @override
  Widget build(BuildContext context) {
    // Static promo code list using Map instead of model
    final List<Map<String, dynamic>> promoCodes = [
      {
        "id": "1",
        "name": "WELCOME10",
        "discount": 10,
        "description": "Get 10% off on your first order"
      },
      {
        "id": "2",
        "name": "FREESHIP",
        "discount": 0,
        "description": "Free shipping on orders above \$50"
      },
      {
        "id": "3",
        "name": "SAVE20",
        "discount": 20,
        "description": "Flat 20% off on groceries"
      },
    ];

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
      body: promoCodes.isEmpty
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemCount: promoCodes.length,
              itemBuilder: (context, index) {
                final pObj = promoCodes[index];
                return GestureDetector(
                  onTap: () {
                    if (didSelect != null) {
                      didSelect!(pObj);
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
                          pObj["name"],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TColor.primaryText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          pObj["description"],
                          style: TextStyle(
                            fontSize: 14,
                            color: TColor.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (pObj["discount"] > 0)
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
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
    );
  }
}
