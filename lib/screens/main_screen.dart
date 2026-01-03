import 'package:coffe_finder/screens/favorite_screen.dart';
import 'package:coffe_finder/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../data/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.coffeeBrown,
      extendBody: true,
      body: IndexedStack(index: _index, children: _pages),

      bottomNavigationBar: _FloatingBottomNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FloatingBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = const [
      ("Home", Icons.home_outlined),
      ("Favorites", Icons.favorite_border),
      ("Profile", Icons.person_outline),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Material(
          color: AppColors.creamSoft,
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            height: 78,
            child: Row(
              children: List.generate(items.length, (i) {
                final selected = i == currentIndex;

                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => onTap(i),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.cream.withOpacity(0.55)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(items[i].$2, size: 24, color: AppColors.coffeeText),
                          const SizedBox(height: 6),
                          Text(
                            items[i].$1,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.coffeeText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
