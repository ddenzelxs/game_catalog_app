class Screenshot {
  final int id;
  final String image;

  Screenshot({
    required this.id,
    required this.image,
  });

  factory Screenshot.fromJson(Map<String, dynamic> json) {
    return Screenshot(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
    );
  }
}