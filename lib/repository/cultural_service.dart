import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cultural_event_model.dart';

class CulturalService {
  final String baseUrl = 'https://cullecting.site/cultural/latestcultural';

  Future<Map<String, List<CulturalEvent>>> fetchCulturalEvents(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['data']['result'] as Map<String, dynamic>;
      print("성공");
      return result.map((key, value) {
        final events = (value as List)
            .map((event) => CulturalEvent.fromJson(event))
            .toList();
        return MapEntry(key, events);
      });
    } else {
      throw Exception('Failed to load cultural events');
    }
  }
}
