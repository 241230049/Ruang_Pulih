class EducationalContent {
  final String id;
  final String title;
  final String category; // 'Psikologi', 'Finansial', 'Strategi Pemulihan', 'Hukum'
  final String summary;
  final String body;
  final String readTime;
  final String author;
  final String publishedDate;
  final bool isFeatured;

  const EducationalContent({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.body,
    required this.readTime,
    required this.author,
    required this.publishedDate,
    this.isFeatured = false,
  });
}

