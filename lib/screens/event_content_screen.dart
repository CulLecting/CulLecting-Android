import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../viewmodels/event_content_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import '../models/event_detail_model.dart';
import 'package:url_launcher/url_launcher.dart';

class EventContentScreen extends StatelessWidget {
  const EventContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventContentViewModel>(
      builder: (context, viewModel, _) {
        final event = viewModel.eventDetail;
        return Scaffold(
          // 배경색을 살짝 탁한 흰색으로 설정
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => viewModel.popScreen(context)
            ),
            actions: [
              IconButton(
                onPressed: () {
                  if (event != null && event.orgLink.isNotEmpty) {
                    Share.share(event.orgLink, subject: '공유하기');
                  }
                },
                icon: const Icon(Icons.share, color: Colors.black),
              ),
            ],
          ),
          body: Consumer<EventContentViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (event == null)
                return const Center(
                  child: Text(
                    "데이터가 없습니다.",
                    style: TextStyle(color: Colors.black54),
                  ),
                );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 코덴임 표시 카드
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Text(
                        event.codename,
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 이벤트 타이틀
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 이벤트 상세 정보 카드
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              event.mainImg,
                              width: 110, // 고정 너비 사용
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                showTexts("장소", event.place),
                                SizedBox(height: 15),
                                showTexts(
                                  "기간",
                                  event.startDate + " ~ " + event.endDate,
                                ),
                                SizedBox(height: 15),
                                showTexts(
                                  "시간",
                                  DateFormat('HH:mm').format(
                                        DateTime.parse(event.startDate),
                                      ) +
                                      " ~ " +
                                      DateFormat(
                                        'HH:mm',
                                      ).format(DateTime.parse(event.endDate)),
                                ),
                                SizedBox(height: 15),
                                showTexts(
                                  "       ",
                                  "누구나 · ${event.free ? '무료' : '유료'}",
                                ),
                              ],
                            ),

                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 홈페이지 바로가기 리스트타일
                    goHomePage(event),
                    // Divider 또는 Container로 구분선을 추가
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    goReview(),

                    // 주소 및 지도
                    const SizedBox(height: 16),
                    map(event)
                    // GoogleMap 위젯: 흰색 배경과 테두리로 지도 영역 표시

                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  showTexts(String first, String second) {
    return Row(
      children: [
        Text(
          first,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(width: 10),
        // Expanded로 감싸 가로 제약을 부여하여 자동 줄바꿈이 일어나도록 함.
        Expanded(
          child: Text(
            second,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            softWrap: true, // 기본적으로 true 이지만 명시해 줍니다.
          ),
        ),
      ],
    );
  }


  Widget goHomePage(EventDetail event) {
    return ListTile(
      tileColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      title: const Text(
        "홈페이지 바로가기",
        style: TextStyle(color: Colors.black87),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.black54,
      ),
      onTap: () async {
        // event.orgLink에 연결된 링크를 외부 브라우저로 실행합니다.
        final Uri url = Uri.parse(event.orgLink);
        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        } else {
          // 실행되지 않는 경우 에러 처리
          throw 'Could not launch $url';
        }
      },
    );
  }

  Widget goReview() {
    return ListTile(
      tileColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      title: const Text(
        "리뷰 보기",
        style: TextStyle(color: Colors.black87),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.black54,
      ),
      onTap: () {
        // 리뷰 보기
      },
    );
  }

  Widget map(EventDetail event) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Text(
                  "주소",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 20),
                // Expanded로 감싸서 사용할 수 있는 영역 내에서 자동 wrap되도록 함.
                Expanded(
                  child: Text(
                    "${event.guname} ${event.place}",
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                    softWrap: true,
                    // 필요 시 overflow 옵션을 조정할 수 있음.
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // 좌우 여백을 주어 지도 크기가 Container보다 약간 작게 보이도록 함
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GoogleMap(
                  // event.lot, event.lat 값을 double로 변환해서 사용
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(event.lot),
                      double.parse(event.lat),
                    ),
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId("eventPin"),
                      position: LatLng(
                        double.parse(event.lot),
                        double.parse(event.lat),
                      ),
                    ),
                  },
                  // 지도에서의 드래그 등 제스처가 유연하게 작동하도록 설정
                  gestureRecognizers:
                  <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                    ),
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
