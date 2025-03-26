import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalendarViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("홈 화면")),
      body: SingleChildScrollView(
        // 세로 스크롤 가능하게 만듦
        child: Column(
          mainAxisSize: MainAxisSize.min, // 🔥 Column이 내용 크기만큼만 차지하도록 설정
          children: [
            showCalendar(context), // 캘린더
            SizedBox(height: 20), // 여백
            viewModel.selectedDayImages.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("해당 날짜에 공연이 없습니다.",style: TextStyle(fontSize: 20),),
                  ),
                )
                : showPosters(context), // 포스터
            SizedBox(height: 30), //  여백
            showRecommendedEvents(context), // 여행지 추천 리스트 추가
            SizedBox(height: 20), //  여백
          ],
        ),
      ),
    );
  }

  /// 🎭 **선택한 날짜에 해당하는 공연 포스터 리스트**
  /// - 가로 스크롤 가능
  /// - 이미지 크기를 작게 조정하여 여러 개가 한눈에 보이도록 설정
  Widget showPosters(BuildContext context) {
    final viewModel = Provider.of<CalendarViewModel>(context, listen: false);

    return SizedBox(
      height: 300, // 이미지 크기 조정 (기존 200 → 100)
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 가로 스크롤 활성화
        itemCount: viewModel.selectedDayImages.length,
        itemBuilder: (context, index) {
          String imagePath = viewModel.selectedDayImages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0), // 🔥 간격 줄이기
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8), // 이미지 둥글게
              child: Image.asset(
                imagePath,
                width: 200, // 이미지 크기 조정 (기존 200 → 100)
                height: 400, // 높이도 동일하게 조정
                fit: BoxFit.contain, // 이미지 비율 유지
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 50, color: Colors.red);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget showRecommendedEvents(BuildContext context) {
    final viewModel = Provider.of<CalendarViewModel>(context, listen: false);

    if (viewModel.selectedDayEvents.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: Text("이날 추천 여행지가 없습니다.", style: TextStyle(fontSize: 18))),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "추천 여행지",
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event["title"] ?? "",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
  }

  /// 📅 **캘린더 위젯**
  /// - 선택한 날짜에 따라 ViewModel에서 변경 처리
  /// - `TableCalendar` 사용
  Widget showCalendar(BuildContext context) {
    final viewModel = Provider.of<CalendarViewModel>(context, listen: false);
    //print('변화가 감지됨'); listen: true로 놓으니까 내가 캘린더 누를 때마다 계속 호출하고 앉아있음. 잘생각해야할듯.

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
}
