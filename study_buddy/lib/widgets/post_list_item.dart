import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/post.dart';

class PostListItem extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onDelete;

  const PostListItem({
    super.key,
    required this.post,
    this.onTap,
    this.onFavorite,
    this.onDelete,
  });

  Widget _buildImage() {
    final img = post.image;

    if (img == null || img.isEmpty) {
      return _errorImage();
    }

    if (img.startsWith('http')) {
      return SizedBox(
        width: double.infinity,
        height: 220,
        child: Image.network(
          img,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: Colors.grey.shade200,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (_, __, ___) => _errorImage(),
        ),
      );
    }

    try {
      final bytes = base64Decode(img);
      return SizedBox(
        width: double.infinity,
        height: 220,
        child: Image.memory(
          bytes,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => _errorImage(),
        ),
      );
    } catch (_) {
      return _errorImage();
    }
  }

  Widget _errorImage() {
    return Container(
      width: double.infinity,
      height: 220,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            print(
              'PostListItem tapped for post: ${post.title ?? post.description}',
            );
            if (onTap != null) {
              onTap!();
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: _buildImage(),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title?.trim().isNotEmpty == true
                            ? post.title!
                            : 'Tanpa Judul',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.description ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            child: Icon(Icons.person),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              post.userFullName ?? 'Unknown User',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: onFavorite,
                            splashRadius: 22,
                            icon: Icon(
                              post.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                          ),
                          if (onDelete != null)
                            IconButton(
                              onPressed: onDelete,
                              splashRadius: 22,
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
