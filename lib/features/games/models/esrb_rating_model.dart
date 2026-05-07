class EsrbRating {
  final int id;
  final String name;
  final String slug;

  EsrbRating({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory EsrbRating.fromJson(Map<String, dynamic> json) {
    return EsrbRating(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}