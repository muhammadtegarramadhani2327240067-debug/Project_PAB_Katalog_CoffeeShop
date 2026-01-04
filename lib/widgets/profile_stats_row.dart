import 'package:flutter/material.dart';
import '../../data/app_colors.dart';

class ProfileStatsCard extends StatelessWidget {
  final int favorites;
  final int reviews;
  final int visited;

  const ProfileStatsCard({
    super.key,
    required this.favorites,
    required this.reviews,
    required this.visited,
  });

  Widget _box(String label, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.creamSoft,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.coffeeText.withOpacity(0.75),
                fontWeight: FontWeight.w800,
                fontFamily: 'serif',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "$value",
              style: const TextStyle(
                color: AppColors.coffeeText,
                fontWeight: FontWeight.w900,
                fontFamily: 'serif',
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _box("Favorites", favorites),
        const SizedBox(width: 12),
        _box("Reviews", reviews),
        const SizedBox(width: 12),
        _box("Visited", visited),
      ],
    );
  }
}