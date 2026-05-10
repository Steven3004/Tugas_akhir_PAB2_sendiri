import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final User? user;
  final bool isSigningOut;
  final VoidCallback onSignOut;

  const ProfileCard({
    super.key,
    required this.user,
    required this.isSigningOut,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                user?.displayName?.isNotEmpty == true
                    ? user!.displayName![0].toUpperCase()
                    : 'S',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, ${user?.displayName ?? 'StudyBuddy User'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.email ?? 'Belum login',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            if (isSigningOut)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            else
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: onSignOut,
              ),
          ],
        ),
      ),
    );
  }
}

class FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final MaterialColor color;
  final VoidCallback onTap;
  final bool selected;

  const FeatureChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? color.withAlpha((0.25 * 255).round())
          : color.withAlpha((0.15 * 255).round()),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: color.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCategorySection extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const FeatureCategorySection({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.blue.shade50,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kategori Fitur',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FeatureChip(
                  icon: Icons.forum_outlined,
                  label: 'Forum',
                  color: Colors.indigo,
                  selected: selectedCategory == 'Forum',
                  onTap: () => onCategorySelected('Forum'),
                ),
                FeatureChip(
                  icon: Icons.event_outlined,
                  label: 'Event Belajar',
                  color: Colors.teal,
                  selected: selectedCategory == 'Event Belajar',
                  onTap: () => onCategorySelected('Event Belajar'),
                ),
                FeatureChip(
                  icon: Icons.storefront_outlined,
                  label: 'Marketplace',
                  color: Colors.deepOrange,
                  selected: selectedCategory == 'Marketplace',
                  onTap: () => onCategorySelected('Marketplace'),
                ),
                FeatureChip(
                  icon: Icons.menu_book_outlined,
                  label: 'Berbagi Materi',
                  color: Colors.purple,
                  selected: selectedCategory == 'Berbagi Materi',
                  onTap: () => onCategorySelected('Berbagi Materi'),
                ),
                FeatureChip(
                  icon: Icons.clear,
                  label: 'Semua',
                  color: Colors.grey,
                  selected: selectedCategory.isEmpty,
                  onTap: () => onCategorySelected(''),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
