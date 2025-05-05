import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/color_extension.dart';
import '../../common_widget/address_row.dart';
import '../../controllers/address_controller.dart';
import '../../controllers/checkout_controller.dart';
import '../account/add_address_view.dart';

class SelectAddressView extends StatefulWidget {
  const SelectAddressView({super.key});

  @override
  State<SelectAddressView> createState() => _SelectAddressViewState();
}

class _SelectAddressViewState extends State<SelectAddressView> {
  final AddressController addressController = Get.put(AddressController());
  final CheckoutController checkoutController = Get.find<CheckoutController>();

  @override
  void initState() {
    super.initState();
    addressController.fetchAddresses();
  }

  void selectAddress(Map<String, dynamic> addressJson) {
    checkoutController.selectedAddress.value = addressJson;
    Get.back(); // go back after selection
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
          "Select Delivery Address",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(() => AddAddressView(isEdit: false));
              addressController.fetchAddresses();
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
        if (addressController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (addressController.addresses.isEmpty) {
          return const Center(child: Text('No addresses found.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          itemCount: addressController.addresses.length,
          itemBuilder: (context, index) {
            final address = addressController.addresses[index];
            final selectedId = checkoutController.selectedAddress['_id'] ?? '';
            final isSelected = selectedId == address.id;

            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? TColor.primary : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddressRow(
                    name: address.fullName,
                    phone: address.phone,
                    address: address.address,
                    city: address.city,
                    state: address.state,
                    postalCode: address.pincode.toString(),
                    onTap: () {}, // Disable tap inside row to avoid confusion
                    didUpdateDone: () => setState(() {}),
                    onRemove: () {},
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        backgroundColor: TColor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => selectAddress(address.toJson()),
                      child: Text(
                        isSelected ? "Selected" : "Select",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
        );
      }),
    );
  }
}
