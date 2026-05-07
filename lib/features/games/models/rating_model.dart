class Rating {
  final int id;
  final String title;
  final int count;
  final double percent;

  Rating({
    required this.id,
    required this.title,
    required this.count,
    required this.percent,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      count: json['count'] ?? 0,
      percent: (json['percent'] ?? 0).toDouble(),
    );
  }
}