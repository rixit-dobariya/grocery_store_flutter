import 'package:flutter/material.dart';
import '../../common_widget/line_textfield.dart';
import '../../common_widget/round_button.dart';
import '../../common/color_extension.dart';

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
    this.initialType = "Home", // Default to "Home"
    this.isEdit = false,
  });

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  late TextEditingController txtName;
  late TextEditingController txtPhone;
  late TextEditingController txtAddress;
  late TextEditingController txtCity;
  late TextEditingController txtState;
  late TextEditingController txtPostalCode;
  late String txtType;

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

  void saveAddress() {
    // You can call your add or update API here
    // Pass the collected data (txtName, txtPhone, etc.) to your API method

    // For example, if editing:
    if (widget.isEdit) {
      // Update logic with the passed `widget.aObj`
      // Call your update API and pass the data
      Navigator.pop(context); // Close the screen after successful operation
    } else {
      // Add logic
      Navigator.pop(context); // Close the screen after successful operation
    }
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
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              // Type selection (Home/Office)
              Row(
                children: [
                  _buildRadioOption("Home"),
                  _buildRadioOption("Office"),
                ],
              ),
              const SizedBox(height: 15),
              // Name field
              LineTextField(
                title: "Name",
                placeholder: "Enter your name",
                controller: txtName,
              ),
              const SizedBox(height: 15),
              // Phone field
              LineTextField(
                title: "Mobile",
                placeholder: "Enter your mobile number",
                keyboardType: TextInputType.phone,
                controller: txtPhone,
              ),
              const SizedBox(height: 15),
              // Address field
              LineTextField(
                title: "Address Line",
                placeholder: "Enter your address",
                controller: txtAddress,
              ),
              const SizedBox(height: 15),
              // City and State fields
              Row(
                children: [
                  Expanded(
                    child: LineTextField(
                      title: "City",
                      placeholder: "Enter City",
                      controller: txtCity,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LineTextField(
                      title: "State",
                      placeholder: "Enter State",
                      controller: txtState,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Postal Code field
              LineTextField(
                title: "Postal Code",
                placeholder: "Enter your Postal Code",
                controller: txtPostalCode,
              ),
              const SizedBox(height: 25),
              // Add/Update Address Button
              RoundButton(
                title: widget.isEdit ? "Update" : "Add Address",
                onPressed: saveAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build the radio option buttons
  Widget _buildRadioOption(String type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            txtType = type;
          });
        },
        child: Row(
          children: [
            Icon(
              txtType == type
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: TColor.primaryText,
            ),
            const SizedBox(width: 15),
            Text(
              type,
              style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
