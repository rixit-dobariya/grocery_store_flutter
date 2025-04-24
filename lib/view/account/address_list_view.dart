import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/view/account/add_address_view.dart';
import '../../common/color_extension.dart';
import '../../common_widget/address_row.dart';

class AddressListView extends StatefulWidget {
  final Function(Map<String, dynamic>)? didSelect;

  const AddressListView({super.key, this.didSelect});

  @override
  State<AddressListView> createState() => _AddressListViewState();
}

class _AddressListViewState extends State<AddressListView> {
  // Sample list of addresses, you can replace this with your dynamic data
  List<Map<String, dynamic>> listArr = [
    {
      "name": "John Doe",
      "phone": "+1234567890",
      "address": "123, Elm Street, NY",
      "city": "New York",
      "state": "NY",
      "postalCode": "10001",
      "typeName": "Home"
    },
    {
      "name": "Jane Smith",
      "phone": "+0987654321",
      "address": "456, Oak Avenue, LA",
      "city": "Los Angeles",
      "state": "CA",
      "postalCode": "90001",
      "typeName": "Office"
    },
    {
      "name": "Alice Brown",
      "phone": "+1122334455",
      "address": "789, Pine Lane, SF",
      "city": "San Francisco",
      "state": "CA",
      "postalCode": "94101",
      "typeName": "Home"
    },
  ];

  void removeAddress(int index) {
    setState(() {
      listArr.removeAt(index);
    });
  }

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
          icon: Image.asset("assets/img/back.png", width: 20, height: 20),
        ),
        centerTitle: true,
        title: Text(
          "Delivery Address",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // Simulate adding a new address and refreshing the list
              await Get.to(() => AddAddressView(
                    isEdit: false, // Set to false for adding new address
                  ));
              setState(() {}); // Refresh the list after adding a new address
            },
            icon: Image.asset(
              "assets/img/add.png",
              width: 20,
              height: 20,
              color: TColor.primaryText,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        itemCount: listArr.length,
        itemBuilder: (context, index) {
          var address = listArr[index];
          return AddressRow(
            name: address["name"],
            phone: address["phone"],
            address: address["address"],
            city: address["city"],
            state: address["state"],
            postalCode: address["postalCode"],
            typeName: address["typeName"],
            onTap: () {
              // Call the function if it's not null
              if (widget.didSelect != null) {
                widget.didSelect!(address);
                Navigator.pop(context);
              }
            },
            didUpdateDone: () {
              // Trigger the update callback after edit
              setState(() {});
            },
            onRemove: () {
              // Remove the address from the list
              removeAddress(index);
            },
          );
        },
        separatorBuilder: (_, __) =>
            const Divider(color: Colors.black12, height: 1),
      ),
    );
  }
}
