import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ProfileData {
  final String fullname;
  final String email;
  final String? photoBase64;

  ProfileData({
    required this.fullname,
    required this.email,
    this.photoBase64,
  });

  String get usernameFromEmail {
    final at = email.indexOf("@");
    final base = at > 0 ? email.substring(0, at) : email;
    return "@$base";
  }
}

class AuthService {
  static Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isSignedIn") ?? false;
  }

  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isSignedIn", false);
  }

  static Future<ProfileData?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final email = prefs.getString("email") ?? "";
    final photoBase64 = prefs.getString("profilePhoto");

    final fullnameEnc = prefs.getString("fullname") ?? "";
    final fullname = await _decryptIfPossible(prefs, fullnameEnc) ?? "User";

    return ProfileData(
      fullname: fullname,
      email: email,
      photoBase64: photoBase64,
    );
  }

  static Future<void> updateProfileNamePhoto({
    required String fullname,
    String? photoBase64,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final crypto = await _ensureCrypto(prefs);
    final encrypter = encrypt.Encrypter(encrypt.AES(crypto.$1));
    final iv = crypto.$2;

    final fullnameEnc = encrypter.encrypt(fullname, iv: iv).base64;
    await prefs.setString("fullname", fullnameEnc);

    if (photoBase64 != null) {
      await prefs.setString("profilePhoto", photoBase64);
    }
  }

  static Future<bool> signUp({
    required String email,
    required String password,
    required String fullname,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final e = email.trim();
    final f = fullname.trim();

    if (e.isEmpty || password.isEmpty || f.isEmpty) return false;
    if (password.length < 6) return false;

    final crypto = await _ensureCrypto(prefs);
    final encrypter = encrypt.Encrypter(encrypt.AES(crypto.$1));
    final iv = crypto.$2;

    await prefs.setString("email", e);

    final passEnc = encrypter.encrypt(password, iv: iv).base64;
    await prefs.setString("password", passEnc);

    final fullnameEnc = encrypter.encrypt(f, iv: iv).base64;
    await prefs.setString("fullname", fullnameEnc);

    await prefs.setBool("isSignedIn", true);
    return true;
  }

  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString("email") ?? "";
    final savedPassEnc = prefs.getString("password") ?? "";

    if (savedEmail.isEmpty || savedPassEnc.isEmpty) return false;
    if (email.trim() != savedEmail) return false;

    final crypto = await _ensureCrypto(prefs);
    final encrypter = encrypt.Encrypter(encrypt.AES(crypto.$1));
    final iv = crypto.$2;

    try {
      final savedPass = encrypter.decrypt64(savedPassEnc, iv: iv);
      if (savedPass != password) return false;
    } catch (_) {
      return false;
    }

    await prefs.setBool("isSignedIn", true);
    return true;
  }

  static Future<(encrypt.Key, encrypt.IV)> _ensureCrypto(
    SharedPreferences prefs,
  ) async {
    var keyStr = prefs.getString("key") ?? "";
    var ivStr = prefs.getString("iv") ?? "";

    if (keyStr.isEmpty || ivStr.isEmpty) {
      final key = encrypt.Key.fromSecureRandom(32);
      final iv = encrypt.IV.fromSecureRandom(16);
      await prefs.setString("key", key.base64);
      await prefs.setString("iv", iv.base64);
      return (key, iv);
    }

    return (encrypt.Key.fromBase64(keyStr), encrypt.IV.fromBase64(ivStr));
  }

  static Future<String?> _decryptIfPossible(
    SharedPreferences prefs,
    String value,
  ) async {
    if (value.isEmpty) return null;

    final keyStr = prefs.getString("key") ?? "";
    final ivStr = prefs.getString("iv") ?? "";
    if (keyStr.isEmpty || ivStr.isEmpty) return value;

    try {
      final key = encrypt.Key.fromBase64(keyStr);
      final iv = encrypt.IV.fromBase64(ivStr);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      return encrypter.decrypt64(value, iv: iv);
    } catch (_) {
      return value;
    }
  }
}
