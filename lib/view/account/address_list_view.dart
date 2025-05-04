import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/view/account/add_address_view.dart';
import '../../common/color_extension.dart';
import '../../common_widget/address_row.dart';
import '../../controllers/address_controller.dart'; // Import the AddressController

class AddressListView extends StatefulWidget {
  final Function(Map<String, dynamic>)? didSelect;

  const AddressListView({super.key, this.didSelect});

  @override
  State<AddressListView> createState() => _AddressListViewState();
}

class _AddressListViewState extends State<AddressListView> {
  final AddressController addressController =
      Get.put(AddressController()); // Initialize AddressController

  @override
  void initState() {
    super.initState();
    addressController.fetchAddresses(); // Fetch addresses when the page loads
  }

  void removeAddress(int index) {
    setState(() {
      addressController.addresses
          .removeAt(index); // Update the list when an address is removed
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
              addressController
                  .fetchAddresses(); // Refresh the address list after adding a new address
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
      body: Obx(() {
        // Make sure the addresses are being loaded
        if (addressController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (addressController.addresses.isEmpty) {
          return Center(child: Text('No addresses found.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          itemCount: addressController.addresses.length,
          itemBuilder: (context, index) {
            var address = addressController
                .addresses[index]; // Get address from the controller
            return AddressRow(
              name: address.fullName,
              phone: address.phone,
              address: address.address,
              city: address.city,
              state: address.state,
              postalCode: address.pincode.toString(),
              onTap: () {
                // Call the function if it's not null
                if (widget.didSelect != null) {
                  widget.didSelect!(address.toJson());
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
        );
      }),
    );
  }
}
