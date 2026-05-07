class Platform {
  final int id;
  final String name;
  final String slug;

  Platform({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Platform.fromJson(Map<String, dynamic> json) {
    return Platform(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}