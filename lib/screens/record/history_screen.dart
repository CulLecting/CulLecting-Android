import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/history_view_model.dart';
import 'package:example_tabbar2/constant/constants.dart';
import 'dart:ui';
import '../../componenets/recording_carousel.dart';
import '../../componenets/create_recording_card.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> keywords = [
    {'icon': Icons.psychology, 'label': '실험적인'},
    {'icon': Icons.palette, 'label': '현대미술'},
    {'icon': Icons.brush, 'label': '감성 몰입형'},
    {'icon': Icons.search, 'label': '분석적인'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<HistoryViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      myHistoryText(),
                      const SizedBox(height: 30),
                      toggleButton(),
                      const SizedBox(height: 50),
                      viewModel.isRecordCardSelected
                          ? recordingCard()
                          : SizedBox(height: 575, child: likeCard()),
                    ],
                  ),
                ),
              ],
            );

          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          changeImageBottomSheet(context);
        },
        backgroundColor: Colors.black,
        label: Text(
          "+ 기록하기",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Text myHistoryText() {
    return Text(
      '내 기록',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  Widget toggleButton() {
    return Consumer<HistoryViewModel>(
      builder: (context, viewModel, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => viewModel.toggleCard(true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: toogleBoxDecoration(
                    viewModel.isRecordCardSelected,
                  ),
                  child: Text(
                    '기록 카드',
                    style: TextStyle(
                      color:
                          viewModel.isRecordCardSelected
                              ? Color(0xFFFF5401)
                              : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => viewModel.toggleCard(false),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: toogleBoxDecoration(
                    !viewModel.isRecordCardSelected,
                  ),
                  child: Text(
                    '취향 카드',
                    style: TextStyle(
                      color:
                          !viewModel.isRecordCardSelected
                              ? Color(0xFFFF5401)
                              : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget likeCard() {
    return Consumer<HistoryViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔳 위쪽 카드 (회색 박스 + more 버튼)
                Stack(
                  children: [
                    Container(
                      height: 350,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // 팝업 메뉴 등 연결 예정
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 🧠 나의 문화 키워드
                const Text(
                  '나의 문화 키워드',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: viewModel.keywords.map((keyword) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFECE0),
                        border: Border.all(color: const Color(0xFFFF5401)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 4),
                          Text(
                            keyword,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFFFF5401),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // 📊 나의 문화 소비 요약
                const Text(
                  '나의 문화 소비 요약',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    // 총 방문 횟수
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '다녀온 문화행사 수',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '총 ${viewModel.culturalCount}건',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 자주 찾은 분야
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '자주 찾은 분야',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              viewModel.manyCategory,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 80), // FloatingActionButton 공간 확보용
              ],
            ),
          ),
        );
      },
    );
  }


  Widget recordingCard() {
    return RecordingCarousel(
      itemCount: 5, // 카드 개수 (원하시는 대로)
      height: 400, // 카드 높이
      maxScale: 1.0, // 가운데 카드 스케일
      itemBuilder: (context, index) {
        return cards();
      },
    );
  }

  Widget cards() {
    double boxWidth = 250;
    double boxHeight = 400;
    return Consumer<HistoryViewModel>(
      builder: (context, viewModel, child) {
        return SizedBox(
          width: boxWidth,
          height: boxHeight,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  'asset/image/classic.jpg',
                  width: boxWidth,
                  height: boxHeight,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low,
                ),
              ),

              // 🔲 배경 카드 (텍스트 포함)
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // 블러 정도 조절
                  child: Container(
                    width: boxWidth,
                    height: boxHeight,
                    decoration: BoxDecoration(
                      color: viewModel.dominantColor.withOpacity(0.3), // 반투명 효과
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          viewModel.title ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          viewModel.date ?? "",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // 🖼️ 이미지 카드
              Center(
                child: SizedBox(
                  width: boxWidth-50,
                  height: boxHeight-100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'asset/image/classic.jpg',
                      width: 300,
                      height: 420,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
