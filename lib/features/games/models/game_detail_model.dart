class GameDetail {
  final int id;
  final String name;
  final String description;
  final String backgroundImage;
  final int metacritic;
  final double rating;
  final List<String> genres;
  final List<String> screenshots;

  GameDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.backgroundImage,
    required this.metacritic,
    required this.rating,
    required this.genres,
    required this.screenshots,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    return GameDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description_raw'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      metacritic: json['metacritic'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),

      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e['name'].toString())
              .toList() ??
          [],

      screenshots: (json['short_screenshots'] as List<dynamic>?)
              ?.map((e) => e['image'].toString())
              .toList() ??
          [],
    );
  }
}