import 'package:flutter/material.dart';

class MyInputText {
  static Widget buildCustomizedTextField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String labelText,
    required String labelError,
    VoidCallback? onTap,
    bool validateEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextFormField(
        onTap: onTap,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return labelError;
          } else if (validateEmail) {
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
          }
          return null;
        },
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
