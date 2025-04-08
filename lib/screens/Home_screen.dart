import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';
///버튼 모습들을 컴포넌트로 따로 저장해놓기
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: showAppbar(),
      body: SingleChildScrollView(
        // 세로 스크롤 가능하게 만듦
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("최근 문화의 순간들"),
                      SizedBox(width: 8), // 텍스트와 버튼 사이 간격 추가
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '>',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
                // 여기에 플립카드 리스트 추가 (수평 스크롤)


              ],
            ),
            showCalendar(), // 캘린더
            SizedBox(height: 20), // 여백
            viewModel.selectedDayImages.isEmpty
                ? showNullPosters() // 포스터 없을 때
                : showPosters(), // 포스터
            SizedBox(height: 30), //  여백
            showRecommendedEvents(), // 여행지 추천 리스트 추가
            SizedBox(height: 20), //  여백
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget showAppbar() {
    return AppBar(
      title: Text('CulLecting'),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(Icons.search), // 검색 아이콘
          onPressed: () {
            // 검색 기능 추가 (예: 검색 페이지로 이동)
            print("검색 버튼 클릭됨");
          },
        ),
        IconButton(
          icon: Icon(Icons.favorite_border), // 하트 아이콘 (빈 하트)
          onPressed: () {
            // 좋아요 기능 추가 (예: 찜 목록으로 이동)
            print("하트 버튼 클릭됨");
          },
        ),
      ],
    );
  }

  /// 🎭 **선택한 날짜에 해당하는 공연 포스터 리스트**
  /// - 가로 스크롤 가능
  /// - 이미지 크기를 작게 조정하여 여러 개가 한눈에 보이도록 설정
  ///

  Align showNullPosters() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("해당 날짜에 공연이 없습니다.", style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget showPosters() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return SizedBox(
          height: 350, // 🔥 높이 조정 (사진 + 텍스트 포함)
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 가로 스크롤 활성화
            itemCount: viewModel.selectedDayImages.length,
            itemBuilder: (context, index) {
              String imagePath = viewModel.selectedDayImages[index];
              String imageName = "행사 제목"; //  사진 이름 (예제)
              String imageDescription = "장소"; //  사진 설명 (예제)

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), // 🔥 간격 줄이기
                child: Column(
                  //  이미지 + 텍스트를 세로로 배치
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // 이미지 둥글게
                      child: Image.asset(
                        imagePath,
                        width: 200,
                        height: 250,
                        fit: BoxFit.cover, // 화면에 크기 맞춤
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.red,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      imageName,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      imageDescription,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }


  Widget showRecommendedEvents() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.selectedDayEvents.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text("이날 추천 여행지가 없습니다.", style: TextStyle(fontSize: 18)),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "지금 인기 있는 행사",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true, // 🔥 SingleChildScrollView 내부에서 정상적으로 동작하도록 설정
                physics: NeverScrollableScrollPhysics(), // 🔥 내부 스크롤 방지 (바깥 Column의 스크롤을 유지)
                itemCount: viewModel.selectedDayEvents.length,
                itemBuilder: (context, index) {
                  final event = viewModel.selectedDayEvents[index];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event["title"] ?? "",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            event["description"] ?? "",
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }


  /// 📅 **캘린더 위젯**
  /// - 선택한 날짜에 따라 ViewModel에서 변경 처리
  /// - `TableCalendar` 사용
  Widget showCalendar() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1), // 📆 캘린더 시작 날짜
          lastDay: DateTime.utc(2025, 12, 31), // 📆 캘린더 종료 날짜
          focusedDay: viewModel.selectedDay, // 📌 현재 포커스된 날짜
          selectedDayPredicate:
              (day) => isSameDay(day, viewModel.selectedDay), // ✅ 선택된 날짜 표시
          onDaySelected: (selectedDay, focusedDay) {
            viewModel.changeSelectedDay(selectedDay); // 📅 날짜 선택 시 ViewModel에 반영
          },
          calendarFormat: CalendarFormat.week, // 📆 1주 단위로 캘린더 표시
          headerStyle: HeaderStyle(formatButtonVisible: false), // 📌 상단 월/연도 버튼 숨김
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            weekendStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.green, // ✅ 오늘 날짜 색상
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.blue, // ✅ 선택된 날짜 색상
              shape: BoxShape.circle,
            ),
          ),
        );
      }
    );
  }
}
