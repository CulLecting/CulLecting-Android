import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/image_search_view_model.dart';
import '../../viewmodels/history_view_model.dart'; // HistoryViewModel이 정의된 파일 import
import 'recording_screen.dart'; // recording_screen.dart 파일 import

class ImageSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ImageSearchViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "이미지 검색",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: viewModel.searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "행사 이름을 입력하세요",
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
              onSubmitted: (value) {
                viewModel.searchImages(value);
              },
            ),
          ),
          Expanded(
            child: viewModel.isLoading
                ? Center(child: CircularProgressIndicator())
                : viewModel.images.isEmpty
                ? Center(child: Text("검색 결과가 없습니다."))
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: viewModel.images.length,
              itemBuilder: (context, index) {
                final imageData = viewModel.images[index];
                return GestureDetector(
                  onTap: () async {
                    // 이미지 검색 결과에서 선택한 이미지 URL을 사용하여 파일로 변환
                    final pickedFile = await viewModel.pickImageFromSearch(imageData.imageURL);
                    if (pickedFile != null) {
                      // HistoryViewModel을 이용하여 선택된 이미지를 저장
                      final historyViewModel = Provider.of<HistoryViewModel>(context, listen: false);
                      historyViewModel.setPickedImage(pickedFile);
                      // recording_screen.dart 로 이동 (아래는 네이밍 방식에 따라 수정)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecordingScreen()),
                      );
                    } else {
                      print("이미지 선택 실패");
                    }
                  },
                  child: GridTile(
                    child: Image.network(
                      imageData.imageURL,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
