class CoffeShop {
  final String id;
  final String name;
  final String city;
  final double rating;
  final String imageAsset;

  const CoffeShop({
    required this.id,
    required this.name,
    required this.city,
    required this.rating,
    required this.imageAsset,
  });

  factory CoffeShop.fromMap(Map<String, dynamic> map) {
    final ratingMap = (map['rating'] as Map?)?.cast<String, dynamic>() ?? {};
    final photos = (map['photos'] as List?) ?? const [];

    return CoffeShop(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      city: (map['city'] ?? '').toString(),
      rating: (ratingMap['value'] as num?)?.toDouble() ?? 0.0,
      imageAsset: photos.isNotEmpty ? photos.first.toString() : '',
    );
  }
}