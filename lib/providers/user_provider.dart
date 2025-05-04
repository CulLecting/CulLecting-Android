import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  late UserModel _user;

  UserModel get user => _user;

  // 테스트용 초기 데이터 설정
  void loadMockUserData() {
    _user = UserModel(
      id: 'member123',
      email: 'test@example.com',
      nickname: '컬렉팅팅',
      location: ['서울시 강남구', '서울시 마포구'],
      category: ['음악', '디자인'],
    );
    notifyListeners();
  }

  // async API 호출로 사용자 정보를 서버에서 가져오는 메서드
  Future<void> fetchUserFromServer(String token) async {
    try {
      // Dio 인스턴스 생성 (필요에 따라 인터셉터를 추가할 수 있습니다)
      Dio dio = Dio(BaseOptions(
        baseUrl: "https://cullecting.site",
      ));

      Response response = await dio.get(
        "/member/me",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["data"] != null) {
        print("체크");
        // 서버의 응답 데이터를 UserModel에 매핑
        _user = UserModel.fromJson(response.data["data"]);
        print("유저 정보 받아오기 성공: $_user");
        notifyListeners();
      } else {
        print(
            "유저 정보 가져오기 실패: ${response.statusCode}, ${response.data}");
      }
    } catch (e) {
      print("유저 정보 가져오는 중 에러 발생: $e");
    }
  }

  // 닉네임 변경 예시
  void updateNickname(String newNickname) {
    _user = _user.copyWith(nickname: newNickname);
    notifyListeners();
  }

  // 이메일 업데이트 예시
  void updateEmail(String newEmail) {
    _user = _user.copyWith(email: newEmail);
    notifyListeners();
  }

  // 위치 업데이트 예시
  void updateLocation(List<String> newLocation) {
    _user = _user.copyWith(location: newLocation);
    notifyListeners();
  }

  // 카테고리 업데이트 예시
  void updateCategory(List<String> newCategory) {
    _user = _user.copyWith(category: newCategory);
    notifyListeners();
  }

  // 여러 필드를 한꺼번에 업데이트할 수 있는 함수
  void updateUser({
    String? nickname,
    String? email,
    List<String>? location,
    List<String>? category,
  }) {
    _user = _user.copyWith(
      nickname: nickname,
      email: email,
      location: location,
      category: category,
    );
    notifyListeners();
  }
}
