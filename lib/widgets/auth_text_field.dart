import 'package:flutter/material.dart';
import '../data/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppColors.coffeeText,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.coffeeText.withOpacity(0.6),
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: AppColors.creamSoft,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}