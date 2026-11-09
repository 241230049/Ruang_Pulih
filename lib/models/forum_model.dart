class ForumComment {
  final String id;
  final String postId;
  final String userId;
  final String authorName;
  final bool isAnonymous;
  final String content;
  final DateTime createdAt;

  const ForumComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.authorName,
    this.isAnonymous = true,
    required this.content,
    required this.createdAt,
  });
}

class ForumPost {
  final String id;
  final String userId;
  final String authorName;
  final bool isAnonymous;
  final String title;
  final String content;
  final String category;
  final int likes;
  final bool isLiked;
  final List<ForumComment> comments;
  final DateTime createdAt;

  const ForumPost({
    required this.id,
    required this.userId,
    required this.authorName,
    this.isAnonymous = true,
    required this.title,
    required this.content,
    required this.category,
    this.likes = 0,
    this.isLiked = false,
    this.comments = const [],
    required this.createdAt,
  });

  ForumPost copyWith({
    String? id,
    String? userId,
    String? authorName,
    bool? isAnonymous,
    String? title,
    String? content,
    String? category,
    int? likes,
    bool? isLiked,
    List<ForumComment>? comments,
    DateTime? createdAt,
  }) {
    return ForumPost(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      authorName: authorName ?? this.authorName,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

