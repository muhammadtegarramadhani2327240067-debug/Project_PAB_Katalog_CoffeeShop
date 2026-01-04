import 'package:flutter/material.dart';
import '../../data/app_colors.dart';

class ProfileEditButton extends StatelessWidget {
  final VoidCallback onTap;
  const ProfileEditButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cream.withOpacity(0.70),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.coffeeText.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Text(
          "Edit",
          style: TextStyle(
            color: AppColors.coffeeText,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}