import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../data/app_colors.dart';
import '../services/favorites_service.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> coffe;
  const DetailScreen({super.key, required this.coffe});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  bool isSignedIn = false;

  List<Map<String, dynamic>> _extraReviews = [];

  late double _baseRatingValue;
  late int _baseRatingCount;

  double _displayRating = 0.0;
  int _displayCount = 0;

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
    _loadFavoriteStatus();

    final Map<String, dynamic> ratingMap =
        (widget.coffe["rating"] as Map<String, dynamic>?) ?? {};
    _baseRatingValue = (ratingMap["value"] as num?)?.toDouble() ?? 0.0;
    _baseRatingCount = (ratingMap["count"] as num?)?.toInt() ?? 0;

    _displayRating = _baseRatingValue;
    _displayCount = _baseRatingCount;

    _loadExtraReviews();
  }

  String get _idBase {
    final id = (widget.coffe["id"] ?? "").toString().trim();
    final name = (widget.coffe["name"] ?? "").toString().trim();
    return id.isNotEmpty ? id : name;
  }

  String get _favKey => "favorite_$_idBase";

  String get _reviewsKey => "reviews_$_idBase";

  void _checkSignInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final signedIn = prefs.getBool('isSignedIn') ?? false;
    if (!mounted) return;
    setState(() => isSignedIn = signedIn);
  }

  void _loadFavoriteStatus() async {
    final fav = await FavoritesService.isFavorite(_idBase);
    if (!mounted) return;
    setState(() => isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    if (!isSignedIn) {
      Navigator.pushNamed(context, '/signin');
      return;
    }

    final next = !isFavorite;

    await FavoritesService.setFavorite(
      id: _idBase,
      item: widget.coffe, 
      value: next,
    );

    if (!mounted) return;
    setState(() => isFavorite = next);
  }


  Future<void> _loadExtraReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_reviewsKey);

    List<Map<String, dynamic>> loaded = [];
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          loaded = decoded
              .map((e) => (e as Map).cast<String, dynamic>())
              .toList();
        }
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() {
      _extraReviews = loaded;
      _applyRatingWithExtra(_extraReviews);
    });
  }

  Future<void> _saveExtraReviews() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reviewsKey, jsonEncode(_extraReviews));
  }

  void _applyRatingWithExtra(List<Map<String, dynamic>> extras) {
    final baseScore = _baseRatingValue * _baseRatingCount;
    final extraScore = extras.fold<double>(0.0, (sum, r) {
      final v = (r["rating"] as num?)?.toDouble() ?? 0.0;
      return sum + v;
    });

    final totalCount = _baseRatingCount + extras.length;
    if (totalCount <= 0) {
      _displayRating = 0.0;
      _displayCount = 0;
      return;
    }

    _displayRating = (baseScore + extraScore) / totalCount;
    _displayCount = totalCount;
  }

  Future<String> _getDecryptedDisplayName() async {
    final prefs = await SharedPreferences.getInstance();

    final encFull = prefs.getString("fullname") ?? "";
    final encUser = prefs.getString("username") ?? "";
    final keyString = prefs.getString("key") ?? "";
    final ivString = prefs.getString("iv") ?? "";

    if (encFull.isEmpty && encUser.isEmpty) return "User";
    if (keyString.isEmpty || ivString.isEmpty) return "User";

    try {
      final key = encrypt.Key.fromBase64(keyString);
      final iv = encrypt.IV.fromBase64(ivString);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      if (encFull.isNotEmpty) {
        return encrypter.decrypt64(encFull, iv: iv);
      }
      return encrypter.decrypt64(encUser, iv: iv);
    } catch (_) {
      return "User";
    }
  }

  String _todayYmd() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }

  Future<void> _openAddReviewSheet() async {
    if (!isSignedIn) {
      Navigator.pushReplacementNamed(context, '/signin');
      return;
    }

    final displayName = await _getDecryptedDisplayName();
    if (!mounted) return;

    double tempRating = 5.0;
    final commentC = TextEditingController();

    final result = await showModalBottomSheet<Map<String, dynamic>?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.creamSoft,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            Widget starPicker() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final idx = i + 1;
                  final filled = tempRating >= idx;
                  return IconButton(
                    onPressed: () => setSheet(() => tempRating = idx.toDouble()),
                    icon: Icon(
                      filled ? Icons.star : Icons.star_border,
                      color: AppColors.coffeeText,
                    ),
                  );
                }),
              );
            }

            final bottom = MediaQuery.of(ctx).viewInsets.bottom;

            return Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16 + bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.coffeeText.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Tambah Ulasan",
                    style: TextStyle(
                      color: AppColors.coffeeText,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'serif',
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Sebagai: $displayName",
                    style: TextStyle(
                      color: AppColors.coffeeText.withOpacity(0.75),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  starPicker(),

                  TextField(
                    controller: commentC,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Tulis ulasanmu...",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.35),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: AppColors.coffeeText.withOpacity(0.15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coffeeText,
                        foregroundColor: AppColors.creamSoft,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        final comment = commentC.text.trim();
                        if (comment.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Ulasan tidak boleh kosong.")),
                          );
                          return;
                        }

                        Navigator.pop(ctx, {
                          "user": displayName,
                          "rating": tempRating,
                          "comment": comment,
                          "date": _todayYmd(),
                        });
                      },
                      child: const Text(
                        "Simpan Ulasan",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    commentC.dispose();

    if (result == null) return;

    setState(() {
      _extraReviews.insert(0, result);
      _applyRatingWithExtra(_extraReviews);
    });
    await _saveExtraReviews();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ulasan berhasil ditambahkan ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String name = (widget.coffe["name"] ?? "").toString();
    final String description = (widget.coffe["description"] ?? "").toString();
    final String address = (widget.coffe["address"] ?? "").toString();

    final double ratingValue = _displayRating;
    final int ratingCount = _displayCount;

    final List<String> photos = List<String>.from(widget.coffe["photos"] ?? const []);
    final List<dynamic> facilities = (widget.coffe["facilities"] as List?) ?? const [];
    final List<dynamic> menuHighlights = (widget.coffe["menuHighlights"] as List?) ?? const [];
    final List<dynamic> baseReviews = (widget.coffe["reviews"] as List?) ?? const [];
    final Map<String, dynamic>? hours = widget.coffe["hours"] as Map<String, dynamic>?;

    final List<dynamic> reviews = [
      ...baseReviews,
      ..._extraReviews,
    ];

    final String heroTag =
        (widget.coffe["id"] ?? (photos.isNotEmpty ? photos[0] : name)).toString();

    return Scaffold(
      backgroundColor: AppColors.coffeeBrown,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(
                title: name,
                rating: ratingValue,
                count: ratingCount,
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),

              _photoRow(photos, heroTag),
              const SizedBox(height: 12),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: AppColors.coffeeText,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'serif',
                              fontSize: 22,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _toggleFavorite,
                          icon: Icon(
                            isSignedIn && isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isSignedIn && isFavorite ? Colors.red : AppColors.coffeeText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.coffeeText.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Alamat"),
                    const SizedBox(height: 6),
                    Text(
                      address,
                      style: TextStyle(
                        color: AppColors.coffeeText.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("Jam Buka"),
                          const SizedBox(height: 6),
                          Text(
                            _formatHours(hours),
                            style: TextStyle(
                              color: AppColors.coffeeText.withOpacity(0.85),
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("Menu & Harga"),
                          const SizedBox(height: 8),
                          _menuList(menuHighlights),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Fasilitas"),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final f in facilities) _chip(_prettyLabel("$f")),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _sectionTitle("Ulasan Pengguna")),
                        TextButton.icon(
                          onPressed: _openAddReviewSheet,
                          icon: const Icon(Icons.add, size: 18, color: AppColors.coffeeText),
                          label: const Text(
                            "Tambah",
                            style: TextStyle(
                              color: AppColors.coffeeText,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (reviews.isEmpty)
                      Text(
                        "Belum ada ulasan.",
                        style: TextStyle(
                          color: AppColors.coffeeText.withOpacity(0.75),
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    else
                      for (final r in reviews) _reviewTile(r),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _topBar({
    required String title,
    required double rating,
    required int count,
    required VoidCallback onBack,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.creamSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onBack,
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.arrow_back, color: AppColors.coffeeText),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.coffeeText,
                fontWeight: FontWeight.w900,
                fontFamily: 'serif',
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Row(
            children: [
              _starsRow(rating: rating, size: 16),
              const SizedBox(width: 6),
              Text(
                "${rating.toStringAsFixed(1)} ($count)",
                style: TextStyle(
                  color: AppColors.coffeeText.withOpacity(0.85),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _photoRow(List<String> photos, String heroTag) {
    final show = photos.take(3).toList();
    if (show.isEmpty) {
      return Container(
        height: 92,
        decoration: BoxDecoration(
          color: AppColors.creamSoft,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.image, color: AppColors.coffeeText.withOpacity(0.6)),
      );
    }

    return Row(
      children: List.generate(show.length, (i) {
        final img = show[i];
        final child = ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: 1.7,
            child: Image.asset(
              img,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.cream.withOpacity(0.55),
                alignment: Alignment.center,
                child: Icon(Icons.image, color: AppColors.coffeeText.withOpacity(0.6)),
              ),
            ),
          ),
        );

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == show.length - 1 ? 0 : 10),
            child: GestureDetector(
              onTap: () => _previewImage(context, img, heroTag: i == 0 ? heroTag : null),
              child: i == 0 ? Hero(tag: heroTag, child: child) : child,
            ),
          ),
        );
      }),
    );
  }

  void _previewImage(BuildContext context, String asset, {String? heroTag}) {
    showDialog(
      context: context,
      builder: (_) {
        final img = InteractiveViewer(
          child: Image.asset(asset, fit: BoxFit.contain),
        );
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              Center(child: heroTag != null ? Hero(tag: heroTag, child: img) : img),
              Positioned(
                top: 6,
                right: 6,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.creamSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.coffeeText,
        fontWeight: FontWeight.w900,
        fontFamily: 'serif',
        fontSize: 16,
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.cream.withOpacity(0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.coffeeText.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.coffeeText,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _menuList(List<dynamic> menuHighlights) {
    final show = menuHighlights.take(5).toList();
    if (show.isEmpty) {
      return Text(
        "Menu belum tersedia",
        style: TextStyle(
          color: AppColors.coffeeText.withOpacity(0.75),
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Column(
      children: show.map((m) {
        final map = (m as Map?)?.cast<String, dynamic>() ?? {};
        final String name = (map["name"] ?? "-").toString();
        final int priceFrom = (map["priceFrom"] as num?)?.toInt() ?? 0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.coffeeText.withOpacity(0.90),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                priceFrom > 0 ? "${_rpK(priceFrom)}+" : "-",
                style: TextStyle(
                  color: AppColors.coffeeText.withOpacity(0.85),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _reviewTile(dynamic raw) {
    final map = (raw as Map?)?.cast<String, dynamic>() ?? {};
    final String user = (map["user"] ?? "User").toString();
    final double rating = (map["rating"] as num?)?.toDouble() ?? 0.0;
    final String date = (map["date"] ?? "").toString();
    final String comment = (map["comment"] ?? "").toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.cream.withOpacity(0.55),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(Icons.person_outline,
                color: AppColors.coffeeText.withOpacity(0.8)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user,
                        style: const TextStyle(
                          color: AppColors.coffeeText,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    _starsRow(rating: rating, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: AppColors.coffeeText.withOpacity(0.85),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment,
                  style: TextStyle(
                    color: AppColors.coffeeText.withOpacity(0.88),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                if (date.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    date,
                    style: TextStyle(
                      color: AppColors.coffeeText.withOpacity(0.65),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _starsRow({required double rating, double size = 16}) {
    final full = rating.floor().clamp(0, 5);
    final half = (rating - full >= 0.5) ? 1 : 0;
    final empty = 5 - full - half;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < full; i++)
          Icon(Icons.star, size: size, color: AppColors.coffeeText),
        if (half == 1)
          Icon(Icons.star_half, size: size, color: AppColors.coffeeText),
        for (int i = 0; i < empty; i++)
          Icon(Icons.star_border,
              size: size, color: AppColors.coffeeText.withOpacity(0.9)),
      ],
    );
  }

  String _rpK(int value) {
    final k = (value / 1000).round();
    return "Rp${k}k";
  }

  String _prettyLabel(String s) {
    final cleaned = s.replaceAll("_", " ").trim();
    if (cleaned.isEmpty) return s;
    return cleaned
        .split(" ")
        .map((w) => w.isEmpty ? w : "${w[0].toUpperCase()}${w.substring(1)}")
        .join(" ");
  }

  String _formatHours(Map<String, dynamic>? hours) {
    if (hours == null) return "Jam belum tersedia";

    const order = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];
    const label = {
      "mon": "Sen",
      "tue": "Sel",
      "wed": "Rab",
      "thu": "Kam",
      "fri": "Jum",
      "sat": "Sab",
      "sun": "Min",
    };

    final note = (hours["note"] ?? "").toString();

    final entries = <Map<String, String>>[];
    for (final d in order) {
      final v = hours[d];
      if (v is Map) {
        final open = (v["open"] ?? "").toString();
        final close = (v["close"] ?? "").toString();
        if (open.isNotEmpty && close.isNotEmpty) {
          entries.add({"day": d, "open": open, "close": close});
        }
      }
    }

    if (entries.isEmpty) {
      return note.isNotEmpty ? "Tidak ada data jam.\n$note" : "Tidak ada data jam.";
    }

    final sameOpen = entries.every((e) => e["open"] == entries.first["open"]);
    final sameClose = entries.every((e) => e["close"] == entries.first["close"]);

    String main;
    if (sameOpen && sameClose) {
      final open = entries.first["open"]!;
      final close = entries.first["close"]!;
      final firstDay = entries.first["day"]!;
      final lastDay = entries.last["day"]!;
      main = "${label[firstDay]}–${label[lastDay]} $open–$close";
    } else {
      main = "Jam bervariasi";
    }

    if (note.isNotEmpty) return "$main\n$note";
    return main;
  }
}