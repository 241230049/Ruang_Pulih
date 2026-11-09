import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../services/app_state_service.dart';
import 'create_post_sheet.dart';
import 'post_detail_screen.dart';

class ForumTab extends StatefulWidget {
  final AppStateService appState;

  const ForumTab({super.key, required this.appState});

  @override
  State<ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> {
  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final allPosts = widget.appState.forumPosts;
        final filteredPosts = _selectedCategory == 'Semua'
            ? allPosts
            : allPosts.where((p) => p.category == _selectedCategory).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text('Forum Menfess & Curhat'),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.shield_outlined, color: AppColors.textSecondary),
                tooltip: 'Ruang Aman Anonim',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: const Row(
                        children: [
                          Icon(Icons.lock_rounded, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text('Ruang Aman Kamu'),
                        ],
                      ),
                      content: const Text(
                        '1. Identitas asli kamu 100% dirahasiakan.\n'
                        '2. Dilarang promosi link/kode referral judi online.\n'
                        '3. Saling dukung dan no judging!',
                        style: TextStyle(fontSize: 13.5, height: 1.5),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Mengerti'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Horizontal Category Chips
              SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.forumCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, idx) {
                    final cat = AppConstants.forumCategories[idx];
                    final isSelected = _selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppColors.primaryContainer,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedCategory = cat);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Forum Feed
              Expanded(
                child: filteredPosts.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada cerita di kategori ini.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        itemCount: filteredPosts.length,
                        itemBuilder: (context, idx) {
                          final post = filteredPosts[idx];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PostDetailScreen(
                                      postId: post.id,
                                      appState: widget.appState,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Author info
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor: AppColors.primaryContainer,
                                          child: const Text('👤', style: TextStyle(fontSize: 12)),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          post.authorName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 13,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text('•', style: TextStyle(color: AppColors.textMuted)),
                                        const SizedBox(width: 6),
                                        Text(
                                          Formatters.timeAgo(post.createdAt),
                                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            post.category,
                                            style: const TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      post.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      post.content,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                        height: 1.45,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () => widget.appState.toggleLikePost(post.id),
                                          borderRadius: BorderRadius.circular(16),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: post.isLiked ? const Color(0xFFFFE4E6) : const Color(0xFFF8FAFC),
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(
                                                color: post.isLiked ? const Color(0xFFFECDD3) : const Color(0xFFE2E8F0),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                                  size: 14,
                                                  color: post.isLiked ? AppColors.danger : AppColors.textSecondary,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${post.likes}',
                                                  style: TextStyle(
                                                    fontSize: 11.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: post.isLiked ? AppColors.danger : AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8FAFC),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(color: const Color(0xFFE2E8F0)),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.mode_comment_outlined, size: 14, color: AppColors.textSecondary),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${post.comments.length} Respon',
                                                style: const TextStyle(
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            onPressed: () => CreatePostSheet.show(context, widget.appState),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Curhat Anonim', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        );
      },
    );
  }
}
