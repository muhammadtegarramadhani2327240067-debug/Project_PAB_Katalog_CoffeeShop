import 'package:flutter/material.dart';
import '../data/app_colors.dart';
import '../widgets/coffe_logo.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_primary_button.dart';
import '../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    final email = emailC.text.trim();
    final pass = passC.text;

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password wajib diisi.")),
      );
      return;
    }

    final ok = await AuthService.signIn(email: email, password: pass);
    if (!mounted) return;

    if (ok) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login gagal. Cek akun / belum sign up.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final logoW = (w * 0.24).clamp(70.0, 120.0);
    final titleSize = (w * 0.11).clamp(28.0, 50.0);
    final welcomeSize = (w * 0.13).clamp(34.0, 58.0);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.coffeeBrown,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: Column(
              children: [
                const SizedBox(height: 8),
                CoffeLogo(color: AppColors.cream, width: logoW),
                const SizedBox(height: 12),
                Text(
                  "COFFEE\nFINDER",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.cream,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'serif',
                    height: 0.95,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "PALEMBANG",
                  style: TextStyle(
                    color: AppColors.cream,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3.0,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  "WELCOME",
                  style: TextStyle(
                    color: AppColors.cream,
                    fontSize: welcomeSize,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'serif',
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 20),

                AuthTextField(
                  hint: "Email",
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                AuthTextField(
                  hint: "Password",
                  controller: passC,
                  obscure: true,
                ),

                const SizedBox(height: 16),

                AuthPrimaryButton(
                  text: "LOGIN",
                  onTap: _doLogin,
                ),

                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style: TextStyle(
                        color: AppColors.cream.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/signup"),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.cream,
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.cream,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}