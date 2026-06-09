import 'rating_model.dart';
import 'store_element_model.dart';

class GameDetail {
  final int id;
  final String name;
  final String description;
  final String backgroundImage;
  final int metacritic;
  final double rating;
  final List<String> genres;
  final List<String> screenshots;
  final String released;
  final List<String> parentPlatforms;
  final List<Rating> ratings;
  final List<StoreElement> stores;
  final List<String> tags;
  final String? minimumRequirements;
  final String? recommendedRequirements;

  GameDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.backgroundImage,
    required this.metacritic,
    required this.rating,
    required this.genres,
    required this.screenshots,
    required this.released,
    required this.parentPlatforms,
    required this.ratings,
    required this.stores,
    required this.tags,
    this.minimumRequirements,
    this.recommendedRequirements,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    // Extract PC requirements if any
    String? minReqs;
    String? recReqs;
    final platformsList = json['platforms'] as List<dynamic>?;
    if (platformsList != null) {
      for (var p in platformsList) {
        final platformMap = p['platform'] as Map<String, dynamic>?;
        if (platformMap != null && platformMap['slug'] == 'pc') {
          final reqsEn = p['requirements_en'] as Map<String, dynamic>?;
          if (reqsEn != null) {
            minReqs = reqsEn['minimum'] as String?;
            recReqs = reqsEn['recommended'] as String?;
          }
          break;
        }
      }
    }

    // Parse screenshots from screenshots_list (passed from API service) or short_screenshots
    final rawScreenshots = json['screenshots_list'] as List<dynamic>?;
    final shortScreenshots = json['short_screenshots'] as List<dynamic>?;
    
    List<String> screenshotsList = [];
    if (rawScreenshots != null) {
      screenshotsList = rawScreenshots.map((e) => e.toString()).toList();
    } else if (shortScreenshots != null) {
      screenshotsList = shortScreenshots.map((e) => e['image'].toString()).toList();
    }

    return GameDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description_raw'] ?? json['description'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      metacritic: json['metacritic'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e['name'].toString())
              .toList() ??
          [],
      screenshots: screenshotsList,
      released: json['released'] ?? '',
      parentPlatforms: (json['parent_platforms'] as List<dynamic>?)
              ?.map((e) => e['platform']['slug'].toString())
              .toList() ??
          [],
      ratings: (json['ratings'] as List<dynamic>?)
              ?.map((e) => Rating.fromJson(e))
              .toList() ??
          [],
      stores: (json['stores'] as List<dynamic>?)
              ?.map((e) => StoreElement.fromJson(e))
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e['name'].toString())
              .toList() ??
          [],
      minimumRequirements: minReqs,
      recommendedRequirements: recReqs,
    );
  }
}