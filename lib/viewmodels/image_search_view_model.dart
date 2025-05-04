import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageData {
  final String title;
  final String imageURL;

  ImageData({required this.title, required this.imageURL});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      title: json['title'] ?? '',
      imageURL: json['imageURL'] ?? '',
    );
  }
}

class ImageSearchViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  List<ImageData> images = [];

  /// 키워드를 받아 이미지 데이터를 서버에서 검색합니다.
  Future<void> searchImages(String keyword) async {
    isLoading = true;
    notifyListeners();

    final uri = Uri.parse('https://cullecting.site/cultural/images?keyword=$keyword');

    try {
      print("검색 시도");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        // bodyBytes를 UTF-8 디코딩해서 처리
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> data = jsonData['data'];
        images = data.map((item) => ImageData.fromJson(item)).toList();
      } else {
        images = [];
      }
    } catch (e) {
      images = [];
      print("이미지 검색 중 에러 발생: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// 검색 결과의 이미지 URL로부터 파일을 다운받아 임시 파일로 저장합니다.
  Future<File?> pickImageFromSearch(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/picked_image.jpg');
        await file.writeAsBytes(bytes);
        return file;
      } else {
        print("HTTP 에러: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("pickImageFromSearch 중 에러 발생: $e");
      return null;
    }
  }
}
