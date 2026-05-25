import 'dart:io';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../widgets/post_list_item.dart';
import '../models/post.dart';
import '../services/firestore_service.dart';
import '../widgets/post_list_item.dart';
import 'detail_screen.dart';
import 'package:flutter/foundation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _localImage;
  bool _isUploading = false;
  String? _base64Image;

  final FirestoreService _firestoreService = FirestoreService();
  Future<void> _pickAndUploadImage() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final picker = ImagePicker();
  final XFile? picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
  if (picked == null) return;

  // read bytes (works on web + mobile)
  final bytes = await picked.readAsBytes();

  setState(() {
    if (!kIsWeb) _localImage = File(picked.path);
    _base64Image = base64Encode(bytes);
    _isUploading = true;
  });

  try {
    final ref = firebase_storage.FirebaseStorage.instance.ref().child('user_photos').child('${user.uid}.jpg');

    // On Web use putData(bytes), on other platforms use putFile
    if (kIsWeb) {
      await ref.putData(bytes, firebase_storage.SettableMetadata(contentType: 'image/jpeg'));
    } else {
      await ref.putFile(File(picked.path));
    }

    final url = await ref.getDownloadURL();

    await user.updatePhotoURL(url);
    await FirebaseAuth.instance.currentUser?.reload();
    final updated = FirebaseAuth.instance.currentUser;

    setState(() {
      _isUploading = false;
    });

    print('Profile photo uploaded. URL: $url');
    print('Updated user photoURL: ${updated?.photoURL}');

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foto profil diperbarui')));
  } catch (e) {
    setState(() {
      _isUploading = false;
    });
    print('Error uploading profile photo: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal upload foto: $e')));
  }
}

  Future<void> _editName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final controller = TextEditingController(text: user.displayName ?? '');

    final result = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Nama'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nama baru'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    try {
      await user.updateDisplayName(result);
      await FirebaseAuth.instance.currentUser?.reload();
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama diperbarui')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui nama: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User belum login')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage: _base64Image != null
                          ? MemoryImage(base64Decode(_base64Image!))
                                as ImageProvider
                          : (_localImage != null
                                ? FileImage(_localImage!) as ImageProvider
                                : (user.photoURL != null &&
                                          user.photoURL!.isNotEmpty
                                      ? NetworkImage(user.photoURL!)
                                      : null)),
                      child:
                          (user.photoURL == null || user.photoURL!.isEmpty) &&
                              _localImage == null &&
                              _base64Image == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: _isUploading ? null : _pickAndUploadImage,
                        child: _isUploading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.displayName ?? 'Anonymous User',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _editName,
                      icon: const Icon(Icons.edit, color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                Text(
                  user.email ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Postingan Saya',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<List<Post>>(
              stream: _firestoreService.getUserPosts(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.post_add, size: 80, color: Colors.grey),
                        SizedBox(height: 14),
                        Text(
                          'Belum ada postingan',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }

                final posts = snapshot.data!;

                return ListView.builder(
                  itemCount: posts.length,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemBuilder: (context, index) {
                    final post = posts[index];

                    return PostListItem(
                      post: post,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(post: post),
                          ),
                        );
                      },
                      onFavorite: () async {
                        await _firestoreService.toggleFavorite(
                          post.id!,
                          post.isFavorite,
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
    );
  }
}
