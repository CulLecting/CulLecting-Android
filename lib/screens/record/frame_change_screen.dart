import 'package:example_tabbar2/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/history_view_model.dart';
import 'dart:ui';

class FrameChangeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HistoryViewModel>(context);

    final frameCircleImages = [
      'asset/image/colorcips/green.png',
      'asset/image/colorcips/white.png',
      'asset/image/colorcips/black.png',
      'asset/image/colorcips/light_grass.png',
      'asset/image/colorcips/sky.png',
      'asset/image/colorcips/check.png',
      'asset/image/colorcips/flower.png',
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 상단 바
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => viewModel.popScreen(context),
                        child: const Icon(Icons.close, size: 30),
                      ),
                      const Spacer(),
                      const Text(
                        '프레임 변경',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 24), // close 아이콘과 균형
                    ],
                  ),
                ),

                // 이미지 표시 영역 (임시 공간)
                Expanded(child: recordingFrontCard()),

                // 프레임 선택 리스트
                SizedBox(
                  height: 50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(frameCircleImages.length, (
                        index,
                      ) {
                        return frameCircle(
                          frameCircleImages[index],
                          index,
                          viewModel,
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 120),
              ],
            ),

            // 하단 고정 버튼
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: undefinedButton,
                  child: const Text(
                    '선택',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget frameCircle(String imagePath, int index, HistoryViewModel viewModel) {
    final isSelected = viewModel.selectedFrameIndex == index;

    return GestureDetector(
      onTap: () {
        viewModel.selectFrame(index); //여기서 직접 색바꿔주기?
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Color(0xFFFF5401) : Colors.transparent,
              width: 3,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              width: 54,
              height: 54,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget recordingFrontCard() {
    return Consumer<HistoryViewModel>(
      builder: (context, viewModel, child) {
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(68),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(68),
                  child:
                      viewModel.changeFrame != null &&
                              viewModel.changeFrame!.isNotEmpty
                          ? Image.asset(
                            viewModel.changeFrame!,
                            width: 350,
                            height: 550,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.low,
                          )
                          : Image.asset(
                            'asset/image/classic.jpg',
                            width: 350,
                            height: 550,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.low,
                          ),
                ),
              ),
            ),

            // 🔲 배경 카드 (텍스트 포함)
            backGround(),

            // 🖼️ 이미지 카드
            Positioned(
              top: 25,
              left: 55,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(68),
                child:
                    viewModel.pickedImage != null
                        ? Image.file(
                          viewModel.pickedImage!,
                          width: 300,
                          height: 420,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                        )
                        : Image.asset(
                          'asset/image/classic.jpg',
                          width: 300,
                          height: 420,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                        ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget backGround() {
    return Consumer<HistoryViewModel>(
      builder: (context, viewModel, child) {
        return Positioned(
          top: 0,
          left: 30,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(68),
            child: BackdropFilter(
              filter:
                  viewModel.changeFrame != null &&
                          viewModel.changeFrame!.isNotEmpty
                      ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                      : ImageFilter.blur(sigmaX: 20, sigmaY: 20), // 블러 정도 조절
              child: Container(
                width: 350,
                height: 550,
                decoration: BoxDecoration(
                  color: viewModel.dominantColor.withOpacity(0.3), // 반투명 효과
                  borderRadius: BorderRadius.circular(68),
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
        );
      },
    );
  }
}
