import 'package:flutter/material.dart';

class CalendarViewModel extends ChangeNotifier {
  // 선택된 날짜
  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;

  // 날짜에 따라 보여줄 이미지들
  final Map<DateTime, List<String>> _events = {
    DateTime(2025, 3, 25): [
      'asset/image/image1.jpg', 'asset/image/image2.jpg',
      'asset/image/image3.jpg', 'asset/image/image4.jpg',
      'asset/image/image5.jpg', 'asset/image/image6.jpg', 'asset/image/image7.jpg'
    ],
    DateTime(2025, 3, 26): ['asset/image/image3.jpg', 'asset/image/image4.jpg'],
    // 🔥 추가 가능
  };

  List<String> _selectedDayImages = [];
  List<String> get selectedDayImages => _selectedDayImages;

  // 🔥 날짜별 행사 추천 리스트
  final Map<DateTime, List<Map<String, String>>> _recommendedEvents = {
    DateTime(2025, 3, 25): [
      {
        "title": "서울 재즈 페스티벌",
        "description": "서울에서 열리는 최고의 재즈 공연을 즐겨보세요.",
      },
      {
        "title": "한강 야시장",
        "description": "다양한 길거리 음식과 공연이 펼쳐지는 한강 야시장!",
      },
      {
        "title": "재즈가 뭐라고 생각하세요?",
        "description": "상대방의 그 호흡, 화합",
      },
      {
        "title": "아니?",
        "description": "샤빱두비두밥 두비두비두비두비두비두밥"
      }
    ],
    DateTime(2025, 3, 26): [
      {
        "title": "벚꽃 축제",
        "description": "화려한 벚꽃 아래에서 산책을 즐겨보세요.",
      },
      {
        "title": "전통 국악 공연",
        "description": "한국 전통 국악의 아름다움을 느껴보세요.",
      },
    ],
  };

  List<Map<String, String>> _selectedDayEvents = [];
  List<Map<String, String>> get selectedDayEvents => _selectedDayEvents;

  // 🔥 날짜 변경 처리
  void changeSelectedDay(DateTime day) {
    _selectedDay = _normalizeDate(day);  // 날짜 비교를 위한 변환
    _selectedDayImages = _events[_selectedDay] ?? [];  // 해당 날짜의 이미지 리스트
    _selectedDayEvents = _recommendedEvents[_selectedDay] ?? []; // 해당 날짜의 행사 리스트
    notifyListeners();  // 상태 변경 후 리스너에게 알리기
  }

  // 🔥 날짜를 '년-월-일' 형식으로 변환하는 함수
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
