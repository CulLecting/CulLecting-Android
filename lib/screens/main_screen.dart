import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/bottom_nav_viewmodel.dart';
import 'Home_screen.dart';
import 'search_screen.dart';
import 'mypage_screen.dart';
import 'history_screen.dart';

class MainScreen extends StatelessWidget {

  final List<Widget> _pages = [ // 여기에서 페이지 전부 관리해서 띄워줌
    HomeScreen(),
    SearchScreen(),
    HistoryScreen(),
    MyPageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: _pages[viewModel.selectedIndex], //보여주는 화면 -> _pages의 n번째
          bottomNavigationBar: _showButton(viewModel) //하단 버튼들
        );
      },
    );
  }

  Widget _showButton (BottomNavViewModel viewModel){
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,  // 네비게이션 바 배경색 (연한 회색)
      selectedItemColor: Colors.blue,     // 선택된 아이콘 및 글자 색상
      unselectedItemColor: Colors.black, // 선택되지 않은 아이콘 및 글자 색상
      currentIndex: viewModel.selectedIndex,
      onTap: (index) => viewModel.changeTab(index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈',),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: '기록'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
      ],
    );
  }
}
