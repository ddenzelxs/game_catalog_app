class AddedByStatus {
  final int yet;
  final int owned;
  final int beaten;
  final int toplay;
  final int dropped;
  final int playing;

  AddedByStatus({
    required this.yet,
    required this.owned,
    required this.beaten,
    required this.toplay,
    required this.dropped,
    required this.playing,
  });

  factory AddedByStatus.fromJson(Map<String, dynamic> json) {
    return AddedByStatus(
      yet: json['yet'] ?? 0,
      owned: json['owned'] ?? 0,
      beaten: json['beaten'] ?? 0,
      toplay: json['toplay'] ?? 0,
      dropped: json['dropped'] ?? 0,
      playing: json['playing'] ?? 0,
    );
  }
}