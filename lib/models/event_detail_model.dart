class EventDetail {
  final int id;
  final String title;
  final String codename;
  final String guname;
  final String place;
  final String orgName;
  final String orgLink;
  final String mainImg;
  final String themeCode;
  final String startDate;
  final String endDate;
  final String date;
  final String lot;
  final String lat;
  final String hmpgAddr;
  final bool free;

  EventDetail({
    required this.id,
    required this.title,
    required this.codename,
    required this.guname,
    required this.place,
    required this.orgName,
    required this.orgLink,
    required this.mainImg,
    required this.themeCode,
    required this.startDate,
    required this.endDate,
    required this.date,
    required this.lot,
    required this.lat,
    required this.hmpgAddr,
    required this.free,
  });

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      id: json['id'],
      title: json['title'],
      codename: json['codename'],
      guname: json['guname'],
      place: json['place'],
      orgName: json['orgName'],
      orgLink: json['orgLink'],
      mainImg: json['mainImg'],
      themeCode: json['themeCode'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      date: json['date'],
      lot: json['lot'],
      lat: json['lat'],
      hmpgAddr: json['hmpgAddr'],
      free: json['free'],
    );
  }
}
