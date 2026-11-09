class FundDistribution {
  final String id;
  final String title;
  final double amount;
  final String date;
  final String recipient;
  final String description;

  const FundDistribution({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.recipient,
    required this.description,
  });
}

class DonationItem {
  final String id;
  final String campaignId;
  final String donorName;
  final bool isAnonymous;
  final double amount;
  final String message;
  final DateTime createdAt;

  const DonationItem({
    required this.id,
    required this.campaignId,
    required this.donorName,
    this.isAnonymous = false,
    required this.amount,
    required this.message,
    required this.createdAt,
  });
}

class DonationCampaign {
  final String id;
  final String title;
  final String category;
  final double targetAmount;
  final double currentAmount;
  final String story;
  final int donorCount;
  final String organizer;
  final List<FundDistribution> distributions;
  final List<DonationItem> recentDonations;
  final DateTime createdAt;

  const DonationCampaign({
    required this.id,
    required this.title,
    required this.category,
    required this.targetAmount,
    required this.currentAmount,
    required this.story,
    required this.donorCount,
    required this.organizer,
    this.distributions = const [],
    this.recentDonations = const [],
    required this.createdAt,
  });

  double get progressPercentage {
    if (targetAmount <= 0) return 0;
    final double p = currentAmount / targetAmount;
    return p > 1.0 ? 1.0 : p;
  }

  DonationCampaign copyWith({
    String? id,
    String? title,
    String? category,
    double? targetAmount,
    double? currentAmount,
    String? story,
    int? donorCount,
    String? organizer,
    List<FundDistribution>? distributions,
    List<DonationItem>? recentDonations,
    DateTime? createdAt,
  }) {
    return DonationCampaign(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      story: story ?? this.story,
      donorCount: donorCount ?? this.donorCount,
      organizer: organizer ?? this.organizer,
      distributions: distributions ?? this.distributions,
      recentDonations: recentDonations ?? this.recentDonations,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

