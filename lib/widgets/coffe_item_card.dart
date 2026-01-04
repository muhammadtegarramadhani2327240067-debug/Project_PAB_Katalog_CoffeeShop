import 'package:flutter/material.dart';
import '../models/coffe_shop.dart';
import '../screens/detail_screen.dart';
import '../data/app_colors.dart';

class CoffeeItemCard extends StatelessWidget {
  final CoffeShop shop;
  final Map<String, dynamic> raw;

  const CoffeeItemCard({super.key, required this.shop, required this.raw});

  @override
  Widget build(BuildContext context) {
    final String name = shop.name;
    final String city = shop.city;
    final double ratingValue = shop.rating;

    final String address = (raw["address"] ?? "").toString();
    final List<String> photos = List<String>.from(raw["photos"] ?? const []);
    final String heroTag = (raw["id"] ?? (photos.isNotEmpty ? photos[0] : name)).toString();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(coffe: raw)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 1,
        color: AppColors.creamSoft,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'serif',
                        color: AppColors.coffeeText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      city,
                      style: TextStyle(
                        color: AppColors.coffeeText.withOpacity(0.75),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: AppColors.coffeeText),
                        const SizedBox(width: 4),
                        Text(
                          ratingValue.toStringAsFixed(1),
                          style: TextStyle(
                            color: AppColors.coffeeText.withOpacity(0.85),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.coffeeText.withOpacity(0.70),
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 80,
                height: 80,
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: photos.isNotEmpty
                        ? Image.asset(
                            photos[0],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.cream.withOpacity(0.5),
                              child: const Icon(Icons.image, color: AppColors.coffeeText),
                            ),
                          )
                        : Container(
                            color: AppColors.cream.withOpacity(0.5),
                            child: const Icon(Icons.image, color: AppColors.coffeeText),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}