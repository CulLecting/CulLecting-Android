import 'package:flutter/material.dart';
import '../models/cultural_event_model.dart';
import '../repository/cultural_service.dart';
import 'dart:convert';                              // for json.decode
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../viewmodels/event_content_viewmodel.dart';
import '../screens/event_content_screen.dart';

class HomeViewModel extends ChangeNotifier {

  HomeViewModel() {
    // ✅ 뷰모델 생성되자마자 이벤트 불러오기
    latestLoadEvents();
    changeSelectedDay(_selectedDay);
  }
  // 선택된 날짜
  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;
  // 🔥 날짜를 '년-월-일' 형식으로 변환하는 함수
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }


  // 날짜에 따라 보여줄 이미지들
  final Map<DateTime, List<String>> _events = {
    DateTime(2025, 4, 23): [
      'asset/image/image1.jpg', 'asset/image/image2.jpg',
      'asset/image/image3.jpg', 'asset/image/image4.jpg',
      'asset/image/image5.jpg', 'asset/image/image6.jpg', 'asset/image/image7.jpg'
    ],
    DateTime(2025, 4, 24): ['asset/image/image3.jpg', 'asset/image/image4.jpg'],

  };

  List<String> _selectedDayImages = [];
  List<String> get selectedDayImages => _selectedDayImages;

  String getWeekdayKor(int weekday) {
    switch (weekday) {
      case 1: return '월';
      case 2: return '화';
      case 3: return '수';
      case 4: return '목';
      case 5: return '금';
      case 6: return '토';
      case 7: return '일';
      default: return '';
    }
  }


  // 🔥 날짜별 행사 추천 리스트

  List<CulturalEvent> _selectedDayEvents = [];
  List<CulturalEvent> get selectedDayEvents => _selectedDayEvents;

  String? _token;
  bool _isInitialized = false;

  final List<String> categories = ["전체", "음악", "공연/예술", "문화/예술", "축제/야외체험", "전시/미술", "기타"];
  String _selectedCategory = "전체";
  List<CulturalEvent> _selectedEvents = [];

  List<CulturalEvent> get selectedEvents => _selectedEvents;
  String get selectedCategory => _selectedCategory;

  //토큰 초기화
  void initialize(String token) {
    if (_isInitialized) return;
    _token = token;
    _isInitialized = true;
  }

  //최근 열린 문화행사 부르는거
  Future<void> latestLoadEvents() async {
    final response = await http.get(
      Uri.parse("https://cullecting.site/cultural/latest"),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      final result = decoded['data']['result'];

      print("카테고리 키 목록: ${result.keys}"); // 한글 정상 출력돼야 함
      print("_selectedCategory 현재값: $_selectedCategory");

      final eventsJson = result[_selectedCategory] ?? [];

      _selectedEvents = List<CulturalEvent>.from(
        eventsJson.map((e) => CulturalEvent.fromJson(e)),
      );

      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    latestLoadEvents(); // 카테고리 변경 시 다시 불러오기
    notifyListeners(); // 선택한 카테고리 바뀌었으니 추가
  }




// 2. 날짜 선택 시 서버에서 문화행사 불러오기
  void changeSelectedDay(DateTime day) async {
    _selectedDay = _normalizeDate(day);
    _selectedDayImages = _events[_selectedDay] ?? [];
    await fetchCulturalEventsFromDate(_selectedDay); // 🔥 서버에서 문화행사 가져오기
    notifyListeners();
  }

// 3. 날짜로 문화행사 가져오는 함수
  Future<void> fetchCulturalEventsFromDate(DateTime date) async {
    final formattedDate = "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";

    // Uri.https를 사용해서 쿼리 파라미터를 URL에 포함
    final uri = Uri.https(
      "cullecting.site",
      "/cultural/date",
      {"date": formattedDate},
    );

    try {
      final response = await http.get(
        uri,
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print("❌ 응답 본문이 비어 있음");
          _selectedDayEvents = [];
          return;
        }

        final decoded = json.decode(utf8.decode(response.bodyBytes));
        print("🔔 message: ${decoded['message']}");

        final List<dynamic> data = decoded['data'];
        _selectedDayEvents =
            data.map((e) => CulturalEvent.fromJson(e)).toList();
        print("이름: ${_selectedDayEvents[0].id}");
      } else {
        print("❌ 서버 응답 오류: ${response.statusCode}");
        _selectedDayEvents = [];
      }

      notifyListeners();
    } catch (e) {
      print("🔥 예외 발생: $e");
      _selectedDayEvents = [];
    }
  }

  void navigateToEventDetailScreen(BuildContext context, int eventId) {
    // 먼저 event_detail 데이터를 불러옵니다.
    // EventContentViewModel이 아래와 같이 Provider로 MultiProvider에 등록되어 있다고 가정합니다.
    final eventContentVM =
    Provider.of<EventContentViewModel>(context, listen: false);
    eventContentVM.fetchEventDetail(eventId);

    // 데이터 요청 후, EventContentScreen으로 이동합니다.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventContentScreen(),
      ),
    );
  }

}

