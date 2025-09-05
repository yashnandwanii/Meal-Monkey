// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/controllers/password_controller.dart';
import 'package:get/get.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.hintText,
    this.isObscure,
  });
  final TextEditingController controller;
  final String? hintText;
  final RxBool? isObscure;

  @override
  Widget build(BuildContext context) {
    final newController = Get.put(PasswordController());
    return Obx(
      () => TextFormField(
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
          prefixIcon: Icon(
            CupertinoIcons.lock_circle,
            color: Tcolor.primary,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          suffixIcon: isObscure != null
              ? IconButton(
                  icon: Icon(
                    isObscure!.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    isObscure!.value = !isObscure!.value;
                  },
                )
              : null,
        ),
        obscureText: isObscure?.value ?? newController.isPasswordVisible.value,
        enabled: true,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Tcolor.primaryText,
        cursorHeight: 20,
        style: TextStyle(
          color: Tcolor.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
