import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/search_view_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context);
    // 텍스트 컨트롤러에 입력값이 있으면 검색 상태로, 없으면 일반 상태로 판단
    final isSearching = viewModel.searchController.text.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              // 헤더 영역: 고정 높이의 컨테이너 내에 Stack을 사용하여 텍스트 필드 위치를 조정
              SizedBox(
                height: !isSearching ? 170 : 130,
                child: Column(
                  children: [
                    // 상단의 뒤로가기 버튼 및 "검색" 텍스트 (입력값이 없을 때 표시)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isSearching)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: const Text(
                              "검색",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Positioned를 사용하여 텍스트 필드의 위치를 조건에 따라 바로 변경
                    _buildSearchBox(context),
                    const SizedBox(height: 12),
                    // 검색 중일 때만 필터/날짜 버튼 표시
                    if (isSearching)
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // TODO: 필터 기능 구현
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.tune, color: Colors.black),
                                SizedBox(width: 8),
                                Text(
                                  "필터",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: 날짜 선택 기능 구현
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  "날짜",
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_drop_down, color: Colors.black),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              // 검색 결과 리스트
              Expanded(
                child: viewModel.searchResults.isEmpty
                    ? const Center(child: Text("검색 결과가 없습니다."))
                    : ListView.builder(
                  itemCount: viewModel.searchResults.length,
                  itemBuilder: (context, index) {
                    final event = viewModel.searchResults[index];
                    const int nameLimit = 20;
                    return InkWell(
                      onTap: () {
                        // search_view_model에 정의해놓은 navigateToEventDetailScreen 메서드를 호출합니다.
                        viewModel.navigateToEventDetailScreen(context, event.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                event.imageURL,
                                width: 100,
                                height: 125,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title.length > nameLimit
                                        ? '${event.title.substring(0, nameLimit)}...'
                                        : event.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    event.place.length > nameLimit
                                        ? '${event.place.substring(0, nameLimit)}...'
                                        : event.place,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${event.startDate} - ${event.endDate}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 텍스트필드를 생성하는 함수.
  /// Positioned 내에서 사용되므로, 위젯이 재생성되지 않고 상태를 유지합니다.
  Widget _buildSearchBox(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (context, viewModel, _) {
        return TextField(
          controller: viewModel.searchController,
          onChanged: (value) {
            if (value.isNotEmpty) {
              viewModel.fetchSearchResults(value);
            } else {
              viewModel.searchResults.clear();
              viewModel.notifyListeners();
            }
          },
          decoration: InputDecoration(
            hintText: "내가 원하는 문화 컨텐츠를 검색하세요",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        );
      },
    );
  }
}
