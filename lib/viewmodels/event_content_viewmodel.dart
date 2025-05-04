import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/event_detail_model.dart';

class EventContentViewModel extends ChangeNotifier {
  EventDetail? eventDetail;
  bool isLoading = false;
  bool _isInitialized = false;
  String? _token;
  void initialize(String token) {
    if (_isInitialized) return;
    _token = token;
    _isInitialized = true;
  }

  Future<void> fetchEventDetail(int culturalId) async {


    try {
      // 쿼리 파라미터의 값은 반드시 String이어야 합니다.
      final url = Uri.https(
        "cullecting.site",
        "cultural/${culturalId.toString()}",
      );
      print("Generated URL: $url");

      final response = await http.get(url);
      print("Response status: ${response.statusCode}");
      print("Response raw body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(utf8.decode(response.bodyBytes));
        // 추가 디버깅: decoded['data']의 타입과 구조를 확인합니다.
        print("decoded['data'] 타입: ${decoded['data'].runtimeType}");
        print("decoded['data']: ${decoded['data']}");

        // 응답이 아래와 같이 data가 Map인 형태라면 문제가 없을 것입니다.
        eventDetail = EventDetail.fromJson(decoded['data']);
      } else {
        print("❌ 서버 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("🔥 예외 발생: $e");
    }

    notifyListeners();
  }

  void popScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

}
