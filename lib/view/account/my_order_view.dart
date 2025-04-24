import 'package:flutter/material.dart';
import '../../common_widget/my_order_row.dart';
import 'my_order_detail_view.dart';
import '../../common/color_extension.dart';

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({super.key});

  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  List<dynamic> listArr = [
    {
      'orderId': '123',
      'orderStatus': 1,
      'createdDate': '2025-04-22',
      'images': ['https://via.placeholder.com/60'],
      'names': 'Apples, Bananas',
      'deliverType': 1,
      'paymentType': 2,
      'paymentStatus': 2,
    },
    {
      'orderId': '124',
      'orderStatus': 3,
      'createdDate': '2025-04-21',
      'images': ['https://via.placeholder.com/60'],
      'names': 'Oranges',
      'deliverType': 2,
      'paymentType': 1,
      'paymentStatus': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              "assets/img/back.png",
              width: 20,
              height: 20,
            )),
        centerTitle: true,
        title: Text(
          "My Orders",
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: listArr.isEmpty
          ? Center(
              child: Text(
                "No Any Order Placed",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemCount: listArr.length,
              itemBuilder: (context, index) {
                var order = listArr[index];
                return MyOrderRow(
                  orderData: order,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyOrdersDetailView(mObj: order),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
