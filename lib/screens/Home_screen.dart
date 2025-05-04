import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';
import '../componenets/create_recording_card.dart';

///버튼 모습들을 컴포넌트로 따로 저장해놓기
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return SafeArea(
      child: Scaffold(
        // 앱 바나 다른 위젯은 그대로 둡니다.
        body: Column(
          children: [
            customAppBar(),
            Container(
              height: 682,
              child: SingleChildScrollView(
                // 세로 스크롤 가능하게 만듦
                child: Column(
                  children: [
                    showText(),
                    firstRecordButton(),
                    myCultureTime(),
                    eventText(),
                    showCalendar(), // 캘린더
                    const SizedBox(height: 20),
                    viewModel.selectedDayEvents.isEmpty
                        ? showNullPosters() // 포스터 없을 때
                        : showPosters(), // 포스터
                    const SizedBox(height: 30),
                    recentContents(),
                  ],
                ),
              ),
            ),
          ],
        ),
        // 플로팅 버튼 설정
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
      ),
    );
  }
}


  Widget customAppBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 15.0,
        right: 10,
        top: 15.0,
        bottom: 20.0,
      ), // 원하는 만큼 패딩 조절
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'asset/image/logo_orange.png',
            width: 45,
            height: 45,
            fit: BoxFit.fitWidth,
          ),
          IconButton(icon: Icon(Icons.search, size: 35.0), onPressed: () {}),
        ],
      ),
    );
  }

  Widget showText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "최근 문화의 순간들",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 8), // 텍스트와 버튼 사이 간격 추가
          IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios)),
        ],
      ),
    );
  }

  Align showNullPosters() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("해당 날짜에 공연이 없습니다.", style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget showPosters() {
    int nameLimit = 13;

    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return SizedBox(
          height: 350,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.selectedDayEvents.length,
            itemBuilder: (context, index) {
              final event = viewModel.selectedDayEvents[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                // 전체 포스터를 InkWell로 감싸 터치 시 동작하도록 함.
                child: InkWell(
                  onTap: () {
                    // HomeViewModel에 있는 화면 전환 함수를 호출하여 event.id를 전달합니다.
                    viewModel.navigateToEventDetailScreen(context, event.id);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          event.imageURL,
                          width: 200,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        event.title.length > nameLimit
                            ? '${event.title.substring(0, nameLimit)}...'
                            : event.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        event.place.length > nameLimit
                            ? '${event.place.substring(0, nameLimit)}...'
                            : event.place,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget firstRecordButton() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  changeImageBottomSheet(context); // 너가 만든 바텀시트 함수 호출
                },
                child: Image.asset(
                  'asset/image/new_recording_button.png',
                  width: 500,
                  height: 250,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget myCultureTime() {
    return Container(
      height: 250, // 기존 400에서 높이를 늘림
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 가로 스크롤
        itemCount: 5, // 예시: 5개의 카드를 표시 (원하는 개수로 조정 가능)
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset(
              'asset/image/classic.jpg',
              width: 175,
              height: 180,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
            ),
          );
        },
      ),
    );
  }

  /// 📅 **캘린더 위젯**
  /// - 선택한 날짜에 따라 ViewModel에서 변경 처리
  /// - `TableCalendar` 사용
  ///
  Widget eventText() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "오늘의 문화 일정",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget showCalendar() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2025, 12, 31),
          focusedDay: viewModel.selectedDay,
          selectedDayPredicate: (day) => isSameDay(day, viewModel.selectedDay),
          onDaySelected: (selectedDay, focusedDay) {
            viewModel.changeSelectedDay(selectedDay);
          },
          calendarFormat: CalendarFormat.week,
          rowHeight: 80,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextFormatter:
                (date, locale) =>
                    "${date.year}.${date.month.toString().padLeft(2, '0')}", // 🔥 포맷 변경
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, size: 24),
            rightChevronIcon: Icon(Icons.chevron_right, size: 24),
          ),
          daysOfWeekHeight: 0, // 요일 따로 숨기기
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final weekday = viewModel.getWeekdayKor(day.weekday);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              final weekday = viewModel.getWeekdayKor(day.weekday);
              return Container(
                width: 50,
                height: 75,
                margin: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weekday,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${day.day}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              final weekday = viewModel.getWeekdayKor(day.weekday);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
            outsideBuilder: (context, day, focusedDay) {
              final weekday = viewModel.getWeekdayKor(day.weekday);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget recentContents() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "최근 열린 문화 콘텐츠",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 15.0),
              // 카테고리 버튼
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      viewModel.categories.map((category) {
                        final bool isSelected =
                            viewModel.selectedCategory == category;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: OutlinedButton(
                            onPressed: () => viewModel.selectCategory(category),
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  isSelected ? Colors.black : Colors.white,
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? Colors.black
                                        : Colors.grey.shade400,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              SizedBox(height: 15.0),

              // 문화 콘텐츠 목록
              ListView.builder(
                shrinkWrap: true, // 내부 자식만큼만 높이를 잡음
                physics: NeverScrollableScrollPhysics(), // 자체 스크롤 비활성화
                itemCount: viewModel.selectedEvents.length,
                itemBuilder: (context, index) {
                  final event = viewModel.selectedEvents[index];
                  return InkWell(
                    onTap: () {
                      // HomeViewModel에 있는 화면 전환 함수를 호출하여 event.id 전달
                      viewModel.navigateToEventDetailScreen(context, event.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: NetworkImage(event.imageURL),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  event.place,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${event.startDate.toLocal().toIso8601String().split("T").first} ~ ${event.endDate.toLocal().toIso8601String().split("T").first}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

