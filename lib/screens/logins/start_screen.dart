import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/logins_viewmodel/start_view_model.dart';
import 'login_screen.dart';  // 로그인 화면
import '../../screens/main_screen.dart';   // 로그인된 경우 이동할 메인 화면

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startViewModel = Provider.of<StartViewModel>(context);

    // 초기화가 완료되고(즉, notifyListeners() 호출 후) 안전하게 네비게이션 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 권한이 승인된 경우에만 화면 전환 (권한 실패 시 별도 처리 필요)
      if (startViewModel.permissionGranted) {
        if (startViewModel.isTokenValid) {
          // 토큰이 유효하면 메인 화면으로 전환 (자동 로그인)
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          // 토큰이 없거나 유효하지 않으면 로그인 화면으로 전환
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }
    });

    return Scaffold(
      // start_page.png가 화면 전체를 덮도록 디자인합니다.
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/image/start_page.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
