import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/view/account/add_address_view.dart';

import '../common/color_extension.dart';

class AddressRow extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final VoidCallback didUpdateDone;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const AddressRow({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.onTap,
    required this.didUpdateDone,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "$address, $city, $state, $postalCode",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      phone,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            // Column(
            //   children: [
            //     IconButton(
            //       onPressed: () async {
            //         // Navigate to AddAddressView for editing
            //         await Get.to(() => AddAddressView(
            //               initialName: name,
            //               initialPhone: phone,
            //               initialAddress: address,
            //               initialCity: city,
            //               initialState: state,
            //               initialPostalCode: postalCode,
            //               isEdit: true,
            //             ));
            //         // Trigger the update callback after edit
            //         didUpdateDone();
            //       },
            //       icon: Icon(
            //         Icons.edit,
            //         color: TColor.primary,
            //         size: 20,
            //       ),
            //     ),
            //     IconButton(
            //       onPressed: onRemove,
            //       icon: Image.asset(
            //         "assets/img/close.png",
            //         width: 15,
            //         height: 15,
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
