import 'package:flutter/material.dart';


Widget MyTextFrom({
  required TextEditingController controller,
  required String labelText,
  TextInputType? keyboardType,
  bool obscureText = false,
  bool isSize = false,
  Widget? prefixIcon,
  Widget? suffixIcon,
  void Function(String)? onFieldSubmitted,
  String? Function(String?)? validator,
  int? maxLength,


}){
  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText:obscureText,
      maxLength: maxLength,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: ' $labelText ',
        counterText: "",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

        ),
        contentPadding: isSize?EdgeInsets.symmetric(vertical: 15):EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
    ),
  );
}