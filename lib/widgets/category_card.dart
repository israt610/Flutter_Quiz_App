import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../models/category_model.dart';
import '../utils/html_utils.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = AppTheme.getCategoryBgColor(category.name, index);
    final decodedName = HtmlUtils.decode(category.name);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              // 3D Visual Graphic in Center
              Positioned.fill(
                bottom: 34,
                child: Center(
                  child: _buildCategoryIllustration(category.name),
                ),
              ),

              // Category Name at Bottom Left
              Positioned(
                left: 14,
                bottom: 14,
                right: 10,
                child: Text(
                  decodedName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIllustration(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('general knowledge')) {
      // 3D Globe with Smiley Face & Planes
      return SizedBox(
        width: 85,
        height: 85,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFF5B7FFF),
                shape: BoxShape.circle,
              ),
            ),
            const Icon(Icons.public, color: Colors.white70, size: 60),
            Positioned(
              top: 8,
              right: 12,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD54F),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.sentiment_satisfied_alt,
                    color: Color(0xFF333333), size: 18),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 2,
              child: Transform.rotate(
                angle: -0.3,
                child: const Icon(Icons.send, color: Color(0xFFFF94B9), size: 24),
              ),
            ),
          ],
        ),
      );
    } else if (lower.contains('book')) {
      // 3D Stack of Books
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_rounded, color: Colors.white, size: 30),
          const SizedBox(height: 2),
          Container(
            width: 75,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFFE25B5B),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: 80,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF3F826D),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: 85,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A359),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      );
    } else if (lower.contains('history')) {
      // 3D Paper Scroll & Red Apple
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 65,
            height: 75,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2C980), width: 1.5),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Color(0xFFE2C980), thickness: 2),
                Divider(color: Color(0xFFE2C980), thickness: 2),
                Divider(color: Color(0xFFE2C980), thickness: 2),
              ],
            ),
          ),
          Positioned(
            bottom: 2,
            right: 4,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFFF4757),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.apple, color: Color(0xFF2ED573), size: 20),
            ),
          ),
        ],
      );
    } else if (lower.contains('science')) {
      // 3D Microscope & Flask
      return const Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.biotech_rounded, color: Color(0xFF3E50B4), size: 70),
          Positioned(
            bottom: 0,
            left: 0,
            child: Icon(Icons.science, color: Color(0xFF8C52FF), size: 30),
          ),
        ],
      );
    } else if (lower.contains('art')) {
      // 3D Crayons in Mug
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD54F),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: Colors.white, size: 30),
          ),
          Positioned(
            top: 2,
            left: 8,
            child: Container(
              width: 14,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 10,
            child: Container(
              width: 14,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4757),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      );
    } else if (lower.contains('vehicle')) {
      // 3D Blue Car
      return const Icon(Icons.directions_car_filled_rounded,
          color: Color(0xFF29B6F6), size: 68);
    } else if (lower.contains('music')) {
      return const Icon(Icons.music_note_rounded,
          color: Color(0xFFFF7043), size: 64);
    } else if (lower.contains('film') || lower.contains('movie')) {
      return const Icon(Icons.movie_rounded,
          color: Color(0xFFAB47BC), size: 64);
    } else if (lower.contains('computer') || lower.contains('video game')) {
      return const Icon(Icons.sports_esports_rounded,
          color: Color(0xFF26A69A), size: 64);
    } else if (lower.contains('sport')) {
      return const Icon(Icons.sports_soccer_rounded,
          color: Color(0xFF66BB6A), size: 64);
    }

    return const Icon(Icons.quiz_rounded,
        color: AppTheme.primaryTeal, size: 60);
  }
}
