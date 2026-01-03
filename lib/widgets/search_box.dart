import 'package:flutter/material.dart';
import '../data/app_colors.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchBox({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(
        color: AppColors.coffeeText,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: 'Search coffee shop',
        hintStyle: TextStyle(
          color: AppColors.coffeeText.withOpacity(0.55),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.coffeeText.withOpacity(0.75),
        ),
        filled: true,
        fillColor: AppColors.creamSoft,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
