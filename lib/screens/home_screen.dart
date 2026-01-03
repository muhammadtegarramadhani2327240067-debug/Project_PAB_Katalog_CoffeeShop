import 'package:flutter/material.dart';
import '../data/app_colors.dart';
import '../data/coffe_shops.dart';
import '../models/coffe_shop.dart';
import '../widgets/coffe_item_card.dart';
import '../widgets/search_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchC = TextEditingController();

  List<Map<String, dynamic>> filteredRaw = coffeShopRaw;

  @override
  void initState() {
    super.initState();
    filteredRaw = coffeShopRaw;
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    final query = q.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredRaw = coffeShopRaw;
      } else {
        filteredRaw = coffeShopRaw.where((m) {
          final name = (m["name"] ?? "").toString().toLowerCase();
          return name.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.coffeeBrown,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                "Coffee Finder",
                style: TextStyle(
                  color: AppColors.cream,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(height: 16),

              SearchBox(controller: searchC, onChanged: _onSearch),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.separated(
                  itemCount: filteredRaw.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, i) {
                    final raw = filteredRaw[i];
                    final CoffeShop shop = CoffeShop.fromMap(raw);

                    return CoffeeItemCard(
                      shop: shop,
                      raw: raw, 
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
}
