import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('🔍 검색 화면입니다', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
