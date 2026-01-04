import 'package:flutter/material.dart';
import '../data/app_colors.dart';
import '../models/coffe_shop.dart';

class CoffeShopCard extends StatelessWidget {
  final CoffeShop shop;
  final VoidCallback? onTap;

  const CoffeShopCard({
    super.key,
    required this.shop,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.creamSoft,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            // kiri (text)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.coffeeText,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shop.city,
                    style: TextStyle(
                      color: AppColors.coffeeText.withOpacity(0.75),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: AppColors.coffeeText),
                      const SizedBox(width: 6),
                      Text(
                        shop.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.coffeeText,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // kanan (gambar)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 72,
                height: 72,
                child: Image.asset(
                  shop.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) {
                    return Container(
                      color: AppColors.cream,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.local_cafe,
                        color: AppColors.coffeeText.withOpacity(0.7),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}