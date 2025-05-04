import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/search_model.dart';
import 'package:provider/provider.dart';
import '../viewmodels/event_content_viewmodel.dart';
import '../screens/event_content_screen.dart';

class SearchViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  List<SearchResult> searchResults = [];
  bool isTyping = false;

  SearchViewModel() {
    searchController.addListener(() {
      isTyping = searchController.text.isNotEmpty;
      notifyListeners();
    });
  }

  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;

  void updateSearchKeyword(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
    // 여기에 API 요청도 바로 연결할 수 있음
    // fetchSearchResults(keyword);
  }



  Future<void> fetchSearchResults(String keyword) async {
    final uri = Uri.https(
      "cullecting.site",
      "/cultural/search",
      {"keyword": keyword},
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        // response.body 대신 response.bodyBytes를 utf8.decode로 처리
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final data = jsonData['data'] as List;
        searchResults = data.map((e) => SearchResult.fromJson(e)).toList();
      } else {
        searchResults = [];
      }
    } catch (e) {
      searchResults = [];
    }

    notifyListeners();
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


  void disposeController() {
    searchController.dispose();
    super.dispose();
  }
}
