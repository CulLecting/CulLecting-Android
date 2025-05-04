import 'package:example_tabbar2/screens/announcement_screen.dart';
import 'package:flutter/material.dart';
import 'package:example_tabbar2/screens/mypage/edit_info_screen.dart'; // 실제 경로로 바꿔줘

class MyPageViewModel extends ChangeNotifier {
  void navigateToEditInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditInfoScreen()),
    );
  }

  void navigateAnn(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AnnouncementScreen()),
    );
  }

}
