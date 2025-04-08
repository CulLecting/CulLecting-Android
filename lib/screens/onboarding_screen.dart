import 'package:flutter/material.dart';
import '../componenets/component.dart'; // cityButton 포함
import 'package:provider/provider.dart';
import '../viewmodels/onboarding_view_model.dart';

class OnboardingScreen extends StatelessWidget {
  final List<String> guList = [
    '서울시 전체',
    '강남구',
    '강동구',
    '강북구',
    '강서구',
    '관악구',
    '광진구',
    '구로구',
    '금천구',
    '노원구',
    '도봉구',
    '동대문구',
    '동작구',
    '마포구',
    '서대문구',
    '서초구',
    '성동구',
    '성북구',
    '송파구',
    '양천구',
    '영등포구',
    '용산구',
    '은평구',
    '종로구',
    '중구',
    '중랑구',
  ];

  final List<String> cultureList = [
    '전시/미술',
    '축제',
    '연극',
    '뮤지컬/오페라',
    '무용',
    '국악',
    '콘서트',
    '클래식',
    '영화',
    '교육/체험',
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          extendBodyBehindAppBar: viewModel.page == 3,
          backgroundColor: Colors.white,
          body:
              viewModel.page == 3
                  ? Stack(
                    children: [
                      SafeArea(
                        top: false, // ✅ 이미지 꽉 채움
                        child: Image.asset(
                          'asset/image/endOnboarding.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: 40,
                        child: pageButton(),
                      ),
                    ],
                  )
                  : SafeArea(
                    child: Column(
                      children: [
                        // 건너뛰기 버튼, 로고 등
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 24.0,
                            left: 12.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [backButton(), passButton()],
                          ),
                        ),
                        SizedBox(height: 20),
                        // 상단 고정 영역 (로고, 건너뛰기, 질문, 진행 바)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              statusBar(),
                              SizedBox(height: 16),
                              // 질문
                              Text(
                                "주로 어디에서 문화 콘텐츠를 즐기세요?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2F2F2F),
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "최대 3개까지 선택할 수 있어요",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF6F6F6F),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),
                        scrollPart(),
                        // 하단 고정 영역
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            bottom: 24,
                            top: 12,
                          ),
                          child: pageButton(),
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }

  Widget passButton() {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, _) {
        return TextButton(
          onPressed: () {},
          child: Text(
            "건너뛰기",
            style: TextStyle(fontSize: 14, color: Color(0xFF6F6F6F)),
          ),
        );
      },
    );
  }

  Widget backButton() {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.page == 1) {
          return const SizedBox.shrink(); // 아무것도 렌더링하지 않음
        }
        return IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 24),
          onPressed: () {
            viewModel.moveBackPage();
          },
          constraints: BoxConstraints(minWidth: 24, minHeight: 24),
          padding: EdgeInsets.zero,
        );
      },
    );
  }

  Widget statusBar() {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: viewModel.page == 2 ? 327 : 163.5,
                height: 4,
                color: const Color(0xFFFF5401), // 주황색
              ),
              Container(
                width: viewModel.page == 2 ? 0 : 163.5,
                height: 4,
                color: const Color(0xFFEAEAEA), // 회색
              ),
            ],
          ),
        );
      },
    );
  }

  Widget pageButton() {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, _) {
        final bool isPage1 = viewModel.page == 1;
        final int selectedCount =
            isPage1 ? viewModel.selectedCity : viewModel.selectedCulture;

        return ElevatedButton(
          onPressed:
              selectedCount > 0
                  ? () {
                    if (viewModel.page == 1) {
                      viewModel.moveNextPage(); // 예: 1 -> 2
                    } else if (viewModel.page == 2) {
                      viewModel.moveNextPage(); // 예: 2 -> 3
                    } else if (viewModel.page == 3) {
                      viewModel.loadMainScreen(context);
                      // 마지막 페이지면 완료 처리
                    }
                  }
                  : null,

          style: ButtonStyle(
            animationDuration: Duration.zero,
            backgroundColor: MaterialStateProperty.resolveWith<Color>((
              Set<MaterialState> states,
            ) {
              return const Color(0xFF2F2F2F); // 🔹 항상 동일한 배경색
            }),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.disabled)) {
                return const Color(0xFFB0B0B0); // 🔸 비활성화 시 텍스트 색
              }
              return Colors.white; // 🔹 활성화 시 텍스트 색
            }),
            minimumSize: MaterialStateProperty.all(const Size(327, 56)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            ),
          ),
          child: Text(
            viewModel.buttonText,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.35,
              letterSpacing: 0,
            ),
          ),
        );
      },
    );
  }

  Widget scrollPart() {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, _) {
        return Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    (viewModel.page == 1 ? guList : cultureList)
                        .map(
                          (item) => onboardingButton(
                            label: item,
                            isSelected:
                                viewModel.page == 1
                                    ? viewModel.isSelectedCity(item)
                                    : viewModel.isSelectedCulture(item),
                            onTap:
                                () =>
                                    viewModel.page == 1
                                        ? viewModel.tapCityButton(item)
                                        : viewModel.tapCultureButton(item),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
