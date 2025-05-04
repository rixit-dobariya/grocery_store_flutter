import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';
import 'package:grocery_store_flutter/view/login/sign_in_view.dart';
import '../../controllers/address_controller.dart';
import '../../models/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddressView extends StatefulWidget {
  final String? initialName;
  final String? initialPhone;
  final String? initialAddress;
  final String? initialCity;
  final String? initialState;
  final String? initialPostalCode;
  final String initialType;
  final bool isEdit;

  const AddAddressView({
    super.key,
    this.initialName,
    this.initialPhone,
    this.initialAddress,
    this.initialCity,
    this.initialState,
    this.initialPostalCode,
    this.initialType = "Home",
    this.isEdit = false,
  });

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController txtName;
  late TextEditingController txtPhone;
  late TextEditingController txtAddress;
  late TextEditingController txtCity;
  late TextEditingController txtState;
  late TextEditingController txtPostalCode;
  late String txtType;

  final AddressController addressController = Get.put(AddressController());

  @override
  void initState() {
    super.initState();
    txtName = TextEditingController(text: widget.initialName);
    txtPhone = TextEditingController(text: widget.initialPhone);
    txtAddress = TextEditingController(text: widget.initialAddress);
    txtCity = TextEditingController(text: widget.initialCity);
    txtState = TextEditingController(text: widget.initialState);
    txtPostalCode = TextEditingController(text: widget.initialPostalCode);
    txtType = widget.initialType;
  }

  @override
  void dispose() {
    txtName.dispose();
    txtPhone.dispose();
    txtAddress.dispose();
    txtCity.dispose();
    txtState.dispose();
    txtPostalCode.dispose();
    super.dispose();
  }

  void saveAddress() async {
    if (_formKey.currentState?.validate() ?? false) {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId'); // Adjust the key if different

      if (userId == null || userId.isEmpty) {
        Get.to(() => SignInView());
        Get.snackbar("Error", "You need to login first!");
        return;
      }

      final newAddress = Address(
        userId: userId,
        fullName: txtName.text.trim(),
        phone: txtPhone.text.trim(),
        address: txtAddress.text.trim(),
        city: txtCity.text.trim(),
        state: txtState.text.trim(),
        pincode: int.tryParse(txtPostalCode.text.trim()) ?? 0,
      );

      await addressController.addAddress(newAddress);

      if (addressController.isLoading.isFalse) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
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
                ),
              ),
              centerTitle: true,
              title: Text(
                widget.isEdit ? "Edit Address" : "Add Address",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      _buildTextFormField(
                        title: "Name",
                        placeholder: "Enter your name",
                        controller: txtName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildTextFormField(
                        title: "Mobile",
                        placeholder: "Enter your mobile number",
                        keyboardType: TextInputType.phone,
                        controller: txtPhone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildTextFormField(
                        title: "Address Line",
                        placeholder: "Enter your address",
                        controller: txtAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Address cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              title: "City",
                              placeholder: "Enter City",
                              controller: txtCity,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'City cannot be empty';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildTextFormField(
                              title: "State",
                              placeholder: "Enter State",
                              controller: txtState,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'State cannot be empty';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildTextFormField(
                        title: "Postal Code",
                        placeholder: "Enter your Postal Code",
                        controller: txtPostalCode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Postal Code cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      RoundButton(
                        onPressed: saveAddress,
                        title: widget.isEdit ? "Update" : "Add Address",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // LOADING OVERLAY
          if (addressController.isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildTextFormField({
    required String title,
    required String placeholder,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
