import 'package:flutter/material.dart';
import '../viewmodels/announcement_view_model.dart';
import 'package:provider/provider.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementViewModel>(
        builder: (context, viewModel, _) {
        return Scaffold(
          // 앱바에 타이틀과 뒤로가기 버튼 배치
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text('공지사항'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => viewModel.navigateToBackPage(context),
            ),
          ),
          // 본문은 중앙에 배치된 메시지
          body: Center(
            // Padding으로 좌우 여백을 주어 읽기 좋은 레이아웃 구성
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // 메인 메시지
                  Text(
                    '공지사항이 비어있어요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  // 보조 메시지
                  Text(
                    '곧 업데이트될 예정입니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
