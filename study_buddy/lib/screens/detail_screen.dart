import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/firestore_service.dart';
import 'map_detail_screen.dart';

class DetailScreen extends StatefulWidget {
  final Post post;
  const DetailScreen({super.key, required this.post});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController commentController = TextEditingController();

  Future<void> _addComment() async {
    if (commentController.text.trim().isEmpty) {
      return;
    }

    try {
      await _firestoreService.addComment(
        widget.post.id ?? '',
        widget.post.userFullName ?? 'Anonymous',
        commentController.text.trim(),
      );

      commentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambahkan komentar: $e')));
    }
  }

  Widget _buildImage() {
    final img = widget.post.image;

    if (img == null || img.isEmpty) {
      return _errorImage();
    }

    // URL IMAGE
    if (img.startsWith('http')) {
      return Image.network(
        img,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 260,

        errorBuilder: (_, __, ___) => _errorImage(),
      );
    }

    try {
      final bytes = base64Decode(img);

      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 260,
        gaplessPlayback: true,

        errorBuilder: (_, __, ___) => _errorImage(),
      );
    } catch (_) {
      return _errorImage();
    }
  }

  Widget _errorImage() {
    return Container(
      height: 260,
      color: Colors.grey.shade300,

      child: const Center(
        child: Icon(Icons.broken_image, size: 70, color: Colors.grey),
      ),
    );
  }

  @override
  void dispose() {
    commentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.post.title ?? 'Detail Post')),

      body: ListView(
        children: [
          _buildImage(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.post.category != null &&
                    widget.post.category!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.post.category!,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                Text(
                  widget.post.title ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  widget.post.description ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const CircleAvatar(child: Icon(Icons.person)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.post.userFullName ?? 'Unknown User',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (widget.post.latitude != null &&
                    widget.post.longitude != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapDetailScreen(post: widget.post),
                          ),
                        );
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('Lihat Lokasi di Map'),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Komentar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Tulis komentar...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height:
                          54, 
                      width: 54, 
                      child: ElevatedButton(
                        onPressed: _addComment,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets
                              .zero, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              14,
                            ), 
                          ),
                        ),
                        child: const Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestoreService.getComments(widget.post.id ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    // EMPTY
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(20),

                        child: Text('Belum ada komentar'),
                      );
                    }
                    final comments = snapshot.data!.docs;
                    return Column(
                      children: comments.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),

                            title: Text(data['userName'] ?? ''),
                            subtitle: Text(data['comment'] ?? ''),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
