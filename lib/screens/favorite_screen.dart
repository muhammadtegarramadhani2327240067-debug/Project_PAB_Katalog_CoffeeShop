import 'package:flutter/material.dart';
import '../data/app_colors.dart';
import '../services/auth_service.dart';
import '../services/favorites_service.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool signedIn = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await AuthService.isSignedIn();
    if (!mounted) return;
    setState(() => signedIn = s);

    if (s) {
      await FavoritesService.refreshCount();
    }
  }

  String _idOf(Map<String, dynamic> raw) {
    final id = (raw["id"] ?? "").toString().trim();
    final name = (raw["name"] ?? "").toString().trim();
    return id.isNotEmpty ? id : name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.coffeeBrown,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Favorites",
                style: TextStyle(
                  color: AppColors.cream,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(height: 14),

              if (!signedIn)
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Kamu belum login",
                        style: TextStyle(
                          color: AppColors.coffeeText,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'serif',
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Login dulu biar daftar favoritmu bisa disimpan & ditampilkan.",
                        style: TextStyle(
                          color: AppColors.coffeeText.withOpacity(0.75),
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.creamSoft,
                            foregroundColor: AppColors.coffeeText,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () async {
                            await Navigator.pushNamed(context, "/signin");
                            await _load();
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: ValueListenableBuilder<int>(
                    valueListenable: FavoritesService.revision,
                    builder: (context, _, __) {
                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: FavoritesService.getFavorites(),
                        builder: (context, snap) {
                          if (!snap.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final items = snap.data!;
                          if (items.isEmpty) {
                            return _card(
                              child: Text(
                                "Belum ada favorit",
                                style: TextStyle(
                                  color: AppColors.coffeeText.withOpacity(0.8),
                                  fontWeight: FontWeight.w800,
                                  height: 1.35,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, i) {
                              final raw = items[i];
                              final name = (raw["name"] ?? "-").toString();
                              final city = (raw["city"] ?? "").toString();
                              final address = (raw["address"] ?? "").toString();
                              final photos = List<String>.from(raw["photos"] ?? const []);
                              final id = _idOf(raw);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.creamSoft,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: photos.isNotEmpty
                                            ? Image.asset(
                                                photos[0],
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => Container(
                                                  color: AppColors.cream.withOpacity(0.55),
                                                  alignment: Alignment.center,
                                                  child: const Icon(Icons.image, color: AppColors.coffeeText),
                                                ),
                                              )
                                            : Container(
                                                color: AppColors.cream.withOpacity(0.55),
                                                alignment: Alignment.center,
                                                child: const Icon(Icons.image, color: AppColors.coffeeText),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => DetailScreen(coffe: raw)),
                                          );
                                        },
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
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            if (city.isNotEmpty)
                                              Text(
                                                city,
                                                style: TextStyle(
                                                  color: AppColors.coffeeText.withOpacity(0.75),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            const SizedBox(height: 2),
                                            Text(
                                              address,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: AppColors.coffeeText.withOpacity(0.7),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () async {
                                        await FavoritesService.setFavorite(
                                          id: id,
                                          item: raw,
                                          value: false,
                                        );
                                      },
                                      icon: const Icon(Icons.favorite, color: Colors.red),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.creamSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}