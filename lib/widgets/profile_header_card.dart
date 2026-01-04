import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../data/app_colors.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String username;
  final String email;
  final String? photoBase64;
  final VoidCallback onEdit;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.username,
    required this.email,
    required this.onEdit,
    this.photoBase64,
  });

  @override
  Widget build(BuildContext context) {
    final bytes = _safeDecode(photoBase64);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.creamSoft,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cream, width: 3),
            ),
            child: ClipOval(
              child: bytes != null
                  ? Image.memory(bytes, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.cream.withOpacity(0.55),
                      alignment: Alignment.center,
                      child: const Icon(Icons.person, color: AppColors.coffeeText),
                    ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.coffeeText,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'serif',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  username,
                  style: TextStyle(
                    color: AppColors.coffeeText.withOpacity(0.75),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.coffeeText.withOpacity(0.75),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Text(
                "Edit",
                style: TextStyle(
                  color: AppColors.coffeeText,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'serif',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Uint8List? _safeDecode(String? b64) {
    try {
      if (b64 == null) return null;
      final t = b64.trim();
      if (t.isEmpty) return null;
      return base64Decode(t);
    } catch (_) {
      return null;
    }
  }
}