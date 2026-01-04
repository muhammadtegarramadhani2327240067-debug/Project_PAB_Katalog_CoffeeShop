import 'package:flutter/material.dart';
import '../data/app_colors.dart';
import '../widgets/coffe_logo.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_primary_button.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmC = TextEditingController();

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    confirmC.dispose();
    super.dispose();
  }

  Future<void> _doSignUp() async {
    final name = nameC.text.trim();
    final email = emailC.text.trim();
    final pass = passC.text;
    final confirm = confirmC.text;

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi.")),
      );
      return;
    }

    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak sama.")),
      );
      return;
    }

    final ok = await AuthService.signUp(email: email, password: pass, fullname: name);
    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Akun dibuat. Silakan login.")),
      );
      Navigator.pushReplacementNamed(context, "/signin");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal sign up. Cek input.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final logoW = (w * 0.22).clamp(65.0, 110.0);
    final titleSize = (w * 0.10).clamp(26.0, 46.0);
    final welcomeSize = (w * 0.12).clamp(32.0, 54.0);

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
                const SizedBox(height: 10),
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
                const SizedBox(height: 18),
                Text(
                  "SIGN UP",
                  style: TextStyle(
                    color: AppColors.cream,
                    fontSize: welcomeSize,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'serif',
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 18),

                AuthTextField(hint: "Full Name", controller: nameC),
                const SizedBox(height: 12),
                AuthTextField(hint: "Email", controller: emailC, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 12),
                AuthTextField(hint: "Password", controller: passC, obscure: true),
                const SizedBox(height: 12),
                AuthTextField(hint: "Confirm Password", controller: confirmC, obscure: true),

                const SizedBox(height: 16),
                AuthPrimaryButton(
                  text: "CREATE ACCOUNT",
                  onTap: _doSignUp,
                ),

                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: AppColors.cream.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Sign In",
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