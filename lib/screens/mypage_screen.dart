import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('👤 마이페이지 화면입니다', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
