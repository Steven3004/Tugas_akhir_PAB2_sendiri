import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../services/firestore_service.dart';
import '../services/theme_provider.dart';
import '../widgets/post_list_item.dart';
import 'add_post_screen.dart';
import 'detail_screen.dart';
import 'favorite_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  final User? currentUser = FirebaseAuth.instance.currentUser;

  // ================= LOGOUT =================
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      // ================= APPBAR =================
      appBar: AppBar(
        title: const Text('Study Buddy'),

        actions: [
          // ================= DARK MODE =================
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme();
            },

            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),

          // ================= FAVORITE =================
          IconButton(
            onPressed: () {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (_) => const FavoriteScreen()),
              );
            },

            icon: const Icon(Icons.favorite),
          ),

          // ================= PROFILE =================
          IconButton(
            onPressed: () {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },

            icon: const Icon(Icons.person),
          ),

          // ================= LOGOUT =================
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),

      // ================= BODY =================
      body: StreamBuilder<List<Post>>(
        stream: _firestoreService.getPosts(),

        builder: (context, snapshot) {
          // ================= LOADING =================
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ================= ERROR =================
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // ================= EMPTY =================
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada postingan'));
          }

          final posts = snapshot.data!;

          // ================= POSTS =================
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 100),

            itemCount: posts.length,

            itemBuilder: (context, index) {
              final post = posts[index];

              return PostListItem(
                post: post,
                // ================= DETAIL =================
                onTap: () {
                  try {
                    print(
                      'Navigating to detail for post: ${post.title ?? post.description}',
                    );
                    print('Post ID: ${post.id}');
                    print('Post has image: ${post.image != null}');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(post: post),
                      ),
                    );
                  } catch (e) {
                    print('Navigation error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error navigating to detail: $e')),
                    );
                  }
                },

                // ================= FAVORITE =================
                onFavorite: () async {
                  await _firestoreService.toggleFavorite(
                    post.id!,
                    post.isFavorite,
                  );
                },

                // ================= DELETE =================
                onDelete: post.id == null
                    ? null
                    : () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Hapus Post'),
                              content: const Text(
                                'Apakah Anda yakin ingin menghapus postingan ini?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Hapus'),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirm == true) {
                          await _firestoreService.deletePost(post.id!);
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Postingan dihapus')),
                          );
                        }
                      },
              );
            },
          );
        },
      ),

      // ================= FLOATING BUTTON =================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(builder: (_) => const AddPostScreen()),
          );
        },

        icon: const Icon(Icons.add),

        label: const Text('Add Post'),
      ),
    );
  }
}
