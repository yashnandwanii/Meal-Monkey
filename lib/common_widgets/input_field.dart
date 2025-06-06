// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:get/get.dart';

class InputField extends StatelessWidget {
  InputField({
    super.key,
    required this.controller,
    this.hintText,
    this.isObscure,
    this.suffixicon = false,
    required this.leadingIcon,
  });
  final TextEditingController controller;
  final String? hintText;
  final RxBool? isObscure;
  bool suffixicon = false;
  final IconData leadingIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => value!.isEmpty ? hintText : null,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText ?? 'Enter your password',
        hintStyle: TextStyle(
          color: Tcolor.secondaryText,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Tcolor.textfield,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        // ignore: unnecessary_null_comparison
        prefixIcon: leadingIcon != null
            ? Icon(
                leadingIcon,
                color: Tcolor.primary,
              )
            : Icon(
                Icons.lock,
                color: Tcolor.primary,
              ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        suffixIcon: suffixicon && isObscure != null
            ? Obx(() => IconButton(
                  icon: Icon(
                    isObscure!.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    isObscure!.value = !isObscure!.value;
                  },
                ))
            : null,
      ),
      enabled: true,
      keyboardType: TextInputType.emailAddress,
      obscureText: isObscure?.value ?? false,
      cursorColor: Tcolor.primaryText,
      cursorHeight: 20,
      style: TextStyle(
        color: Tcolor.primaryText,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
