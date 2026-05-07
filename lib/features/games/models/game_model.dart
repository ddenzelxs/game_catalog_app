import 'added_by_status_model.dart';
import 'esrb_rating_model.dart';
import 'genre_model.dart';
import 'platform_element_model.dart';
import 'rating_model.dart';
import 'screenshot_model.dart';
import 'store_element_model.dart';
import 'tag_model.dart';

class Game {
  final int id;
  final String slug;
  final String name;
  final String released;
  final bool tba;
  final String backgroundImage;
  final double rating;
  final int ratingTop;
  final int ratingsCount;
  final int reviewsCount;
  final int added;
  final int metacritic;
  final int playtime;
  final int suggestionsCount;
  final String updated;
  final String saturatedColor;
  final String dominantColor;

  final List<Rating> ratings;
  final AddedByStatus addedByStatus;
  final List<PlatformElement> platforms;
  final List<Genre> genres;
  final List<StoreElement> stores;
  final List<Tag> tags;
  final List<Screenshot> shortScreenshots;

  final EsrbRating? esrbRating;

  Game({
    required this.id,
    required this.slug,
    required this.name,
    required this.released,
    required this.tba,
    required this.backgroundImage,
    required this.rating,
    required this.ratingTop,
    required this.ratingsCount,
    required this.reviewsCount,
    required this.added,
    required this.metacritic,
    required this.playtime,
    required this.suggestionsCount,
    required this.updated,
    required this.saturatedColor,
    required this.dominantColor,
    required this.ratings,
    required this.addedByStatus,
    required this.platforms,
    required this.genres,
    required this.stores,
    required this.tags,
    required this.shortScreenshots,
    this.esrbRating,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      released: json['released'] ?? '',
      tba: json['tba'] ?? false,
      backgroundImage: json['background_image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      ratingTop: json['rating_top'] ?? 0,
      ratingsCount: json['ratings_count'] ?? 0,
      reviewsCount: json['reviews_count'] ?? 0,
      added: json['added'] ?? 0,
      metacritic: json['metacritic'] ?? 0,
      playtime: json['playtime'] ?? 0,
      suggestionsCount: json['suggestions_count'] ?? 0,
      updated: json['updated'] ?? '',
      saturatedColor: json['saturated_color'] ?? '',
      dominantColor: json['dominant_color'] ?? '',
      ratings: (json['ratings'] as List<dynamic>?)
              ?.map((e) => Rating.fromJson(e))
              .toList() ??
          [],
      addedByStatus:
          AddedByStatus.fromJson(json['added_by_status'] ?? {}),
      platforms: (json['platforms'] as List<dynamic>?)
              ?.map((e) => PlatformElement.fromJson(e))
              .toList() ??
          [],
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => Genre.fromJson(e))
              .toList() ??
          [],
      stores: (json['stores'] as List<dynamic>?)
              ?.map((e) => StoreElement.fromJson(e))
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e))
              .toList() ??
          [],
      shortScreenshots:
          (json['short_screenshots'] as List<dynamic>?)
                  ?.map((e) => Screenshot.fromJson(e))
                  .toList() ??
              [],
      esrbRating: json['esrb_rating'] != null
          ? EsrbRating.fromJson(json['esrb_rating'])
          : null,
    );
  }
}