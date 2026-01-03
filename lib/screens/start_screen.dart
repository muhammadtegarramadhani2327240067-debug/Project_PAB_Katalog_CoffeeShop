import 'dart:async';
import 'package:flutter/material.dart';
import '../data/app_colors.dart';
import '../widgets/coffe_logo.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/signin');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final logoW = (w * 0.34).clamp(90.0, 150.0);
    final titleSize = (w * 0.16).clamp(38.0, 64.0);
    final subSize = (w * 0.06).clamp(14.0, 22.0);

    return Scaffold(
      backgroundColor: AppColors.coffeeBrown,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CoffeLogo(color: AppColors.cream, width: logoW),
              const SizedBox(height: 28),

              Text(
                "COFFEE",
                style: TextStyle(
                  color: AppColors.cream,
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'serif',
                  height: 0.95,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                "FINDER",
                style: TextStyle(
                  color: AppColors.cream,
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'serif',
                  height: 0.95,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                "PALEMBANG",
                style: TextStyle(
                  color: AppColors.cream,
                  fontSize: subSize,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'serif',
                  letterSpacing: 3.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
