import 'package:flutter/material.dart';
import '../data/app_colors.dart';
import '../services/auth_service.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_stats_row.dart';
import '../services/favorites_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool signedIn = false;
  ProfileData? profile;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await AuthService.isSignedIn();
    final p = s ? await AuthService.getProfile() : null;

    if (!mounted) return;
    setState(() {
      signedIn = s;
      profile = p;
    });

    if (s) {
      await FavoritesService.refreshCount();
    } else {
      FavoritesService.resetForSignedOut();
    }
  }

  Future<void> _logout() async {
    await AuthService.signOut();
    if (!mounted) return;
    setState(() {
      signedIn = false;
      profile = null;
    });
    FavoritesService.resetForSignedOut();
  }

  Widget _actionButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.creamSoft,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: AppColors.coffeeText.withOpacity(0.18),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.coffeeText,
                fontWeight: FontWeight.w900,
                fontFamily: 'serif',
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = signedIn ? (profile?.fullname ?? "User") : "Guest";
    final email = signedIn ? (profile?.email ?? "") : "Silakan sign in";
    final username = signedIn ? (profile?.usernameFromEmail ?? "@user") : "@guest";
    final photoBase64 = signedIn ? profile?.photoBase64 : null;

    return Scaffold(
      backgroundColor: AppColors.coffeeBrown,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              const Text(
                "Profile",
                style: TextStyle(
                  color: AppColors.cream,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(height: 14),

              ProfileHeaderCard(
                name: name,
                username: username,
                email: email,
                photoBase64: photoBase64,
                onEdit: () async {
                  if (!signedIn) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Sign in dulu untuk edit profile.")),
                    );
                    Navigator.pushNamed(context, "/signin");
                    return;
                  }

                  final changed = await Navigator.pushNamed(context, "/edit-profile");
                  if (changed == true) {
                    await _load();
                  }
                },
              ),

              const SizedBox(height: 14),

              ValueListenableBuilder<int>(
                valueListenable: FavoritesService.count,
                builder: (context, favCount, _) {
                  return ProfileStatsCard(
                    favorites: signedIn ? favCount : 0,
                    reviews: 0,
                    visited: 0,
                  );
                },
              ),

              const SizedBox(height: 18),

              _actionButton(
                text: signedIn ? "Sign Out" : "Sign In",
                onTap: () async {
                  if (signedIn) {
                    await _logout();
                  } else {
                    Navigator.pushNamed(context, "/signin");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}