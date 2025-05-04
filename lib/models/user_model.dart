class UserModel {
  final String id;
  final String email;
  final String nickname;
  final List<String> location;
  final List<String> category;

  UserModel({
    required this.id,
    required this.email,
    required this.nickname,
    required this.location,
    required this.category,
  });

  // 예시로 fromJson도 정의해둘게
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      location: json['location'] is List
          ? List<String>.from(json['location'])
          : json['location'] != null
          ? [json['location'].toString()]
          : [],
      category: json['category'] is List
          ? List<String>.from(json['category'])
          : json['category'] != null
          ? [json['category'].toString()]
          : [],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'location': location,
      'category': category,
    };
  }

  // copyWith 메서드 추가
  UserModel copyWith({
    String? id,
    String? password,
    String? email,
    String? nickname,
    List<String>? location,
    List<String>? category,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      location: location ?? this.location,
      category: category ?? this.category,
    );
  }
}
