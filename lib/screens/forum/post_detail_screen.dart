import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/forum_model.dart';
import '../../services/app_state_service.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  final AppStateService appState;

  const PostDetailScreen({
    super.key,
    required this.postId,
    required this.appState,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.flag_outlined, color: AppColors.danger),
            SizedBox(width: 8),
            Text('Laporkan Postingan'),
          ],
        ),
        content: const Text(
          'Apakah postingan ini mengandung ajakan/promosi judi online, kata-kata kasar, atau doxxing? Tim moderator RuangPulih akan meninjau dan menghapusnya dalam 1 jam.',
          style: TextStyle(fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Laporan diterima. Terima kasih menjaga keamanan komunitas.'),
                  backgroundColor: AppColors.danger,
                ),
              );
            },
            child: const Text('Laporkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final post = widget.appState.forumPosts.firstWhere(
          (p) => p.id == widget.postId,
          orElse: () => ForumPost(
            id: '',
            userId: '',
            authorName: '',
            title: 'Postingan tidak ditemukan',
            content: '',
            category: '',
            createdAt: DateTime.fromMillisecondsSinceEpoch(0),
          ),
        );

        if (post.id.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Postingan')),
            body: const Center(child: Text('Postingan tidak ditemukan')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Diskusi Forum'),
            actions: [
              IconButton(
                icon: const Icon(Icons.flag_outlined, color: AppColors.textSecondary),
                tooltip: 'Laporkan Konten',
                onPressed: _showReportDialog,
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Post Author Header
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primaryLight,
                          child: const Text('🎭', style: TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  post.authorName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                if (post.isAnonymous) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Anonim',
                                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              Formatters.timeAgo(post.createdAt),
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            post.category,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Post Title & Body
                    Text(
                      post.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      post.content,
                      style: const TextStyle(fontSize: 14.5, height: 1.5, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 20),

                    // Like & Comment Count Stats
                    Row(
                      children: [
                        InkWell(
                          onTap: () => widget.appState.toggleLikePost(post.id),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: post.isLiked ? AppColors.dangerLight : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                                  size: 16,
                                  color: post.isLiked ? AppColors.danger : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${post.likes} Dukungan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: post.isLiked ? AppColors.danger : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            const Icon(Icons.mode_comment_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              '${post.comments.length} Respon',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 36),

                    // Comments Section
                    const Text(
                      'Tanggapan & Dukungan Sesama Pejuang',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),

                    if (post.comments.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'Belum ada tanggapan. Berikan kata-kata penyemangat pertama!',
                            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                          ),
                        ),
                      )
                    else
                      ...post.comments.map((comment) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text('💬', style: TextStyle(fontSize: 14)),
                                      const SizedBox(width: 6),
                                      Text(
                                        comment.authorName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    Formatters.timeAgo(comment.createdAt),
                                    style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                comment.content,
                                style: const TextStyle(fontSize: 13, height: 1.4),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),

              // Comment Input Field Bar
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Tulis kata penyemangat...',
                          hintStyle: const TextStyle(fontSize: 13),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          fillColor: AppColors.surfaceVariant,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                      onPressed: () {
                        final text = _commentController.text.trim();
                        if (text.isNotEmpty) {
                          widget.appState.addComment(post.id, text);
                          _commentController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
