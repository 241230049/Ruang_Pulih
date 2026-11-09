import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/education_model.dart';

class ArticleDetailScreen extends StatelessWidget {
  final EducationalContent article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edukasi & Literasi'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tautan artikel disalin. Bagikan ke teman yang membutuhkan.')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              article.category,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            article.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Oleh ${article.author}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(width: 8),
              Text(
                article.readTime,
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
          const Divider(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
            ),
            child: Text(
              article.summary,
              style: const TextStyle(fontSize: 13.5, fontStyle: FontStyle.italic, height: 1.4),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            article.body,
            style: const TextStyle(fontSize: 15, height: 1.6, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

