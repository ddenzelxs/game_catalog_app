class ImageUtils {
  static String getResizedImage(
    String url, {
    int width = 600,
  }) {
    if (url.isEmpty) return '';

    return url.replaceFirst(
      '/media/',
      '/media/resize/$width/-/',
    );
  }
}