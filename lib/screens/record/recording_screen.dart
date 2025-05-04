import 'package:example_tabbar2/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/history_view_model.dart';
import '../../viewmodels/card_flip_view_model.dart';
import '../../componenets/component.dart';
import 'package:example_tabbar2/componenets/flip_card_item.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import '../../componenets/create_recording_card.dart';
//Navigator.pushNamed(context, '/recording'); 나중에 기록카드 연결할 때 사용..

class RecordingScreen extends StatelessWidget {
  const RecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HistoryViewModel>();
    final screenHeight = MediaQuery.of(context).size.height;
    viewModel.updateDominantColor(const AssetImage('asset/image/classic.jpg'));

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                buttons(),
                const SizedBox(height: 20),
                Expanded(
                  child: FlipCardItem(
                    frontCard: recordingFrontCard(),
                    backCard: recordingBackCard(),
                  ),
                ),
                rotateButton(),
                SizedBox(height: 155),
              ],
            ),

            if (viewModel.isMoreMenuVisible)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    viewModel.hideMoreMenu();
                  },
                  child: Container(
                    color: Colors.transparent, // 클릭 이벤트만 감지
                  ),
                ),
              ),

            showMeetBallWidget(),
            // 반투명 배경
            if (viewModel.isBottomSheetOpen ||
                viewModel.isChangeImageBottomShhetOpen)
              GestureDetector(
                onTap: () => viewModel.closeBottomSheet(),
                child: AnimatedOpacity(
                  opacity: viewModel.isBottomSheetOpen ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(color: Colors.black.withOpacity(0.4)),
                ),
              ),

            // 바텀시트
            bottomSheet(screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    String title, {
    Color textColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(title, style: TextStyle(color: textColor, fontSize: 15)),
      ),
    );
  }

  Widget showMeetBallWidget() {
    return Positioned(
      top: 35,
      right: 16,
      child: Consumer<HistoryViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (viewModel.isMoreMenuVisible)
                Container(
                  width: 160,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildMenuItem(
                        '이미지 변경',
                        onTap: () {
                          changeImageBottomSheet(context);
                          viewModel.hideMoreMenu();
                        },
                      ),
                      _buildMenuItem(
                        '프레임 변경',
                        onTap: () {
                          viewModel.resetFrame();
                          viewModel.onChangeFrame(context);
                          viewModel.hideMoreMenu();
                        },
                      ),
                      _buildMenuItem(
                        '공유',
                        onTap: () {
                          viewModel.onShare();
                          viewModel.hideMoreMenu();
                        },
                      ),
                      _buildMenuItem(
                        '삭제',
                        textColor: Colors.red,
                        onTap: () {
                          viewModel.onDelete();
                          viewModel.hideMoreMenu();
                        },
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
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
                borderRadius: BorderRadius.circular(40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(68),
                  child:
                      viewModel.pickedImage != null
                          ? Image.file(
                            viewModel.pickedImage!,
                            width: 350,
                            height: 550,
                            fit: BoxFit.cover,
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
            Positioned(
              top: 0,
              left: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // 블러 정도 조절
                  child: Container(
                    width: 350,
                    height: 550,
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
            ),

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

  Widget recordingBackCard() {
    return Consumer<HistoryViewModel>(
      builder: (context, viewModel, child) {
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child:
                    viewModel.pickedImage != null
                        ? Image.file(
                          viewModel.pickedImage!,
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

            // 🔲 배경 카드 (텍스트 포함)
            Positioned(
              top: 0,
              left: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35), // 블러 정도 조절
                  child: Container(
                    width: 350,
                    height: 550,
                    decoration: BoxDecoration(
                      color: viewModel.dominantColor.withOpacity(0.3), // 반투명 효과
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 23.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.title ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                viewModel.date ?? "",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Image.asset(
                              'asset/image/logo_white.png',
                              width: 30,
                              height: 25,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.low,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 🖼️ 이미지 카드
            // 🖼️ 이미지 카드 (회색 블러 카드)
            Positioned(
              top: 95,
              left: 55,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
                      child: Container(
                        width: 300,
                        height: 370,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17.0,
                        vertical: 20.0,
                      ),
                      child: Container(
                        width: 266,
                        height: 330,
                        child: Text(
                          viewModel.memo ?? "",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showSaveToast(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 40,
            left: MediaQuery.of(context).size.width / 2 - 163.5, // (327 / 2)
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: 327,
                    height: 56,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    decoration: BoxDecoration(
                      color: const Color(0xCC888888),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.white, size: 20),
                        SizedBox(width: 16),
                        Text(
                          "이미지 저장이 완료되었습니다",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Widget buttons() {
    return Consumer<HistoryViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  viewModel.popScreen(context);
                },
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () async {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    viewModel.saveCardToGallery();
                  });
                  showSaveToast(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: viewModel.toggleMoreMenu,
              ),
            ],
          ),
        );
      },
    );
  }


  Widget bottomSheet(double screenHeight) {
    return Consumer<HistoryViewModel>(
      builder: (context, viewModel, child) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom:
              viewModel.isBottomSheetOpen
                  ? 0
                  : -(screenHeight * 0.80 - 130), // 안올렸을 때 100px 보이게
          left: 0,
          right: 0,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! < -10) {
                viewModel.openBottomSheet();
              } else if (details.primaryDelta! > 10) {
                viewModel.closeBottomSheet();
              }
            },
            child: Container(
              height: screenHeight * 0.80, //올렸을 때 차지하는 비율
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 50,
                    offset: const Offset(0, 27), // 위쪽 방향으로 살짝 그림자
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  handle(),
                  Expanded(child: buildBottomSheetContent(context)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget rotateButton() {
    return Consumer<CardFlipViewModel>(
      builder: (context, viewModel, child) {
        return IconButton(
          icon: const Icon(Icons.screen_rotation),
          onPressed: () => viewModel.flipCard(),
        );
      },
    );
  }
  

  Widget buildBottomSheetContent(BuildContext context) {
    //처음 바텀시트
    final viewModel = context.watch<HistoryViewModel>();

    return Stack(
      children: [
        // 스크롤 가능한 콘텐츠
        SingleChildScrollView(
          physics: viewModel.isBottomSheetOpen
              ? const ClampingScrollPhysics()    // 바텀시트가 열린 상태면 스크롤 가능
              : const NeverScrollableScrollPhysics(), // 그렇지 않으면 스크롤 막기
          padding: const EdgeInsets.fromLTRB(
            24,
            12,
            24,
            120,
          ), // 버튼 영역 고려해서 아래 padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 어떤 행사였나요?
              bottomSheetText("어떤 행사였나요?"),
              const SizedBox(height: 8),
              TextField(
                style: TextStyle(fontSize: 13.0),
                controller: viewModel.titleController,
                onChanged: (_) => viewModel.validateTitleLength(),
                decoration: defaultInputDecoration(
                  radius: 12,
                  isError: viewModel.titleLengthErrorMessage != null,
                ),
              ),
              errorBox(
                interval: 20,
                errorMessage: viewModel.titleLengthErrorMessage,
              ),

              // 문화 카테고리
              bottomSheetText("문화 카테고리"),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => showCategoryBottomSheet(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        viewModel.selectedCategory ?? '카테고리 선택',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Icon(Icons.chevron_right_rounded, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 날짜
              bottomSheetText("언제 다녀오셨나요?"),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => showDateBottomSheet(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        viewModel.selectedDate ?? "",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Icon(Icons.chevron_right_rounded, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 메모
              bottomSheetText("어떤 기억이 남았나요?"),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 300,
                child: TextField(
                  style: TextStyle(fontSize: 13.0),
                  controller: viewModel.memoController,
                  onChanged: (_) => viewModel.validateMemoLength(),
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,   // 상단 정렬
                  decoration: defaultInputDecoration(
                    radius: 12,
                    isError: viewModel.memoLengthErrorMessage != null,
                  ),
                ),
              ),
              errorBox(
                interval: 20,
                errorMessage: viewModel.memoLengthErrorMessage,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),

        // 고정된 저장 버튼
        Positioned(
          bottom: 40,
          left: 24,
          right: 24,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  viewModel.isBottomSheetButtonEnabled
                      ? () {
                        viewModel.makeCard();
                        viewModel.closeBottomSheet();
                      }
                      : null, // ❗ null이면 자동으로 비활성화 스타일 적용됨
              style: undefinedButton,
              child: const Text(
                '저장하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.50,
          maxChildSize: 0.8,
          minChildSize: 0.3,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 36), // 아래 여백 중요!
              child: Consumer<HistoryViewModel>(
                builder: (context, viewModel, _) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '카테고리',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children:
                              viewModel.categories.map((category) {
                                return CategoryChip(
                                  label: category,
                                  isSelected:
                                      viewModel.selectedCategoryTemp ==
                                      category,
                                  onTap:
                                      () => viewModel.selectCategory(category),
                                );
                              }).toList(),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              viewModel.confirmCategorySelection();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              '확인',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void showDateBottomSheet(BuildContext context) {
    //캘린더 나오는 바텀시트
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55, // 좀 더 위로 올라오게
          maxChildSize: 0.8,
          minChildSize: 0.4,
          builder: (_, controller) {
            return Consumer<HistoryViewModel>(
              builder: (context, viewModel, _) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${viewModel.displayedYear}년 ${viewModel.displayedMonth}월',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showYearMonthPickerBottomSheet(context);
                            },
                            icon: const Icon(Icons.chevron_right_rounded),
                          ),
                          SizedBox(width: 100),
                          Row(
                            children: [
                              IconButton(
                                onPressed: viewModel.goToPreviousMonth,
                                icon: const Icon(Icons.chevron_left_rounded),
                              ),
                              IconButton(
                                onPressed: viewModel.goToNextMonth,
                                icon: const Icon(Icons.chevron_right_rounded),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TableCalendar(
                        locale: 'ko_KR',
                        firstDay: DateTime(2020),
                        lastDay: DateTime(2030),
                        focusedDay: viewModel.focusedDay,
                        selectedDayPredicate:
                            (day) => isSameDay(viewModel.selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          viewModel.selectDay(selectedDay, focusedDay);
                        },
                        calendarStyle: CalendarStyle(
                          todayTextStyle: const TextStyle(
                            color: Color(0xFFFF5401),
                          ),
                          todayDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          selectedTextStyle: const TextStyle(
                            color: Color(0xFFFF5401),
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: Color(0xFFFFECE0),
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerVisible: false, // 커스텀으로 이미 구현했기 때문에 숨김
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.confirmSelectedDate();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '확인',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void showYearMonthPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer<HistoryViewModel>(
          builder: (context, viewModel, _) {
            final fixedExtentScrollControllerYear = FixedExtentScrollController(
              initialItem: viewModel.tempSelectedYear - 2023,
            );
            final fixedExtentScrollControllerMonth =
                FixedExtentScrollController(
                  initialItem: viewModel.tempSelectedMonth - 1,
                );

            return Container(
              height: 300,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "날짜 선택",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: fixedExtentScrollControllerYear,
                            itemExtent: 40.0,
                            onSelectedItemChanged: (index) {
                              viewModel.setTempSelectedYear(2023 + index);
                            },
                            children: List.generate(10, (index) {
                              final year = 2023 + index;
                              return Center(child: Text('$year년'));
                            }),
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: fixedExtentScrollControllerMonth,
                            itemExtent: 40.0,
                            onSelectedItemChanged: (index) {
                              viewModel.setTempSelectedMonth(index + 1);
                            },
                            children: List.generate(12, (index) {
                              final month = index + 1;
                              return Center(child: Text('$month월'));
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                        onPressed: () {
                          viewModel.confirmYearMonthSelection();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '선택',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
