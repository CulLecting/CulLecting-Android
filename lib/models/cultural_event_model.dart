class CulturalEvent {
  final int id;
  final String title;
  final String imageURL;
  final String place;
  final DateTime startDate;
  final DateTime endDate;

  CulturalEvent({
    required this.id,
    required this.title,
    required this.imageURL,
    required this.place,
    required this.startDate,
    required this.endDate,
  });

  factory CulturalEvent.fromJson(Map<String, dynamic> json) {
    return CulturalEvent(
      id: json['id'],
      title: json['title'],
      imageURL: json['imageURL'],
      place: json['place'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}
