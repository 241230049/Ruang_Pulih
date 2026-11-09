class VolunteerProfile {
  final String id;
  final String userId;
  final String name;
  final String university;
  final String faculty;
  final String bio;
  final List<String> skills;
  final List<String> availableDays;
  final bool isVerified;
  final double rating;
  final int consultationCount;
  final String avatarUrl;

  const VolunteerProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.university,
    required this.faculty,
    required this.bio,
    required this.skills,
    required this.availableDays,
    this.isVerified = true,
    this.rating = 4.9,
    this.consultationCount = 28,
    this.avatarUrl = '🎓',
  });

  VolunteerProfile copyWith({
    String? id,
    String? userId,
    String? name,
    String? university,
    String? faculty,
    String? bio,
    List<String>? skills,
    List<String>? availableDays,
    bool? isVerified,
    double? rating,
    int? consultationCount,
    String? avatarUrl,
  }) {
    return VolunteerProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      university: university ?? this.university,
      faculty: faculty ?? this.faculty,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      availableDays: availableDays ?? this.availableDays,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      consultationCount: consultationCount ?? this.consultationCount,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

