import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/app_colors.dart';
import '../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameC = TextEditingController();

  bool loading = true;
  Uint8List? photoBytes;
  String? photoBase64;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    nameC.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final signedIn = await AuthService.isSignedIn();

    if (!signedIn) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pushReplacementNamed(context, "/signin");
      });
      return;
    }

    final p = await AuthService.getProfile();
    if (!mounted) return;

    setState(() {
      nameC.text = p?.fullname ?? "";
      photoBase64 = p?.photoBase64;

      if (photoBase64 != null && photoBase64!.isNotEmpty) {
        photoBytes = base64Decode(photoBase64!);
      }
      loading = false;
    });
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();

    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.creamSoft,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text("Pilih dari Gallery"),
                  onTap: () => Navigator.pop(context, "gallery"),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text("Ambil dari Kamera"),
                  onTap: () => Navigator.pop(context, "camera"),
                ),
                if (photoBytes != null)
                  ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: const Text("Hapus Foto"),
                    onTap: () => Navigator.pop(context, "remove"),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (choice == null) return;

    if (choice == "remove") {
      setState(() {
        photoBytes = null;
        photoBase64 = "";
      });
      return;
    }

    final source =
        (choice == "camera") ? ImageSource.camera : ImageSource.gallery;

    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1080,
    );
    if (file == null) return;

    final bytes = await file.readAsBytes();
    if (!mounted) return;

    setState(() {
      photoBytes = bytes;
      photoBase64 = base64Encode(bytes);
    });
  }

  Future<void> _save() async {
    final fullname = nameC.text.trim();
    if (fullname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama tidak boleh kosong.")),
      );
      return;
    }

    await AuthService.updateProfileNamePhoto(
      fullname: fullname,
      photoBase64: photoBase64,
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: AppColors.coffeeBrown,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.coffeeBrown, Color(0xFFB56C53)],
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                  sliver: SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                  color: AppColors.coffeeText,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'serif',
                                ),
                              ),
                            ),
                            _pillButton(
                              text: "Cancel",
                              onTap: () => Navigator.pop(context, false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: AppColors.cream, width: 6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.16),
                                      blurRadius: 24,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: photoBytes != null
                                      ? Image.memory(photoBytes!, fit: BoxFit.cover)
                                      : Container(
                                          color: AppColors.cream.withOpacity(0.35),
                                          child: const Icon(
                                            Icons.person,
                                            size: 70,
                                            color: AppColors.coffeeText,
                                          ),
                                        ),
                                ),
                              ),
                              InkWell(
                                onTap: _pickPhoto,
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.creamSoft,
                                    borderRadius: BorderRadius.circular(999),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.14),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: AppColors.coffeeText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          "Name",
                          style: TextStyle(
                            color: AppColors.coffeeText,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'serif',
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),

                        _fieldCard(
                          child: TextField(
                            controller: nameC,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nama kamu",
                            ),
                            style: const TextStyle(
                              color: AppColors.coffeeText,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        const Spacer(),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.creamSoft,
                              foregroundColor: AppColors.coffeeText,
                              elevation: 12,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            onPressed: _save,
                            child: const Text(
                              "Save Changes",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontFamily: 'serif',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pillButton({required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.creamSoft,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
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
    );
  }

  Widget _fieldCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            AppColors.creamSoft.withOpacity(0.85),
            AppColors.cream.withOpacity(0.75),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}