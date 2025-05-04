class SearchResult {
  final int id;
  final String title;
  final String imageURL;
  final String place;
  final String startDate;
  final String endDate;

  SearchResult({
    required this.id,
    required this.title,
    required this.imageURL,
    required this.place,
    required this.startDate,
    required this.endDate,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'],
      title: json['title'],
      imageURL: json['imageURL'],
      place: json['place'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }
}
