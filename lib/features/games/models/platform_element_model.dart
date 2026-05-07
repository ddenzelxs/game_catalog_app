import 'platform_model_model.dart';

class PlatformElement {
  final Platform platform;
  final String releasedAt;

  PlatformElement({
    required this.platform,
    required this.releasedAt,
  });

  factory PlatformElement.fromJson(Map<String, dynamic> json) {
    return PlatformElement(
      platform: Platform.fromJson(json['platform']),
      releasedAt: json['released_at'] ?? '',
    );
  }
}