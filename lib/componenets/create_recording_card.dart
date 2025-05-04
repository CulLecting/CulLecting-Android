import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/history_view_model.dart';
import '../componenets/component.dart';
import 'package:example_tabbar2/screens/record/image_search_screen.dart';


/// 바텀시트에서 호출되는 메인 함수
void changeImageBottomSheet(BuildContext context) {
  final isOnRecordingScreen = ModalRoute.of(context)?.settings.name == '/recording';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (context) {
      return Container(
        height: 230,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            handle(),
            Expanded(
              child: ChangeImageBottomSheetContent(
                onAfterPickImage: () {
                  Navigator.pop(context); // 바텀시트 닫기
                  if (!isOnRecordingScreen) {
                    Navigator.pushNamed(context, '/recording')  ;
                    print("실행됨");
                  }
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}


/// 바텀시트 내부 내용 (재사용 가능하도록 StatelessWidget으로 분리)
class ChangeImageBottomSheetContent extends StatelessWidget {
  final VoidCallback? onAfterPickImage;

  const ChangeImageBottomSheetContent({super.key, this.onAfterPickImage});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HistoryViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildItem(
            icon: Icons.image,
            label: "사진 불러오기",
            onTap: () async {
              // 사진 선택 결과를 받아옵니다.
              final selectedImage = await viewModel.pickImageFromGallery();
              // 선택된 사진이 있다면 onAfterPickImage 호출
              if (selectedImage != null) {
                onAfterPickImage?.call();
              }
            },
          ),
          const SizedBox(height: 35.0),
          _buildItem(
            icon: Icons.photo_camera,
            label: "사진 찍기",
            onTap: () async {
              final selectedImage = await viewModel.pickImageFromCamera();
              if (selectedImage != null) {
                onAfterPickImage?.call();
              }
            },
          ),
          const SizedBox(height: 35.0),
          _buildItem(
            icon: Icons.search,
            label: "검색하기",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageSearchScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 30),
          const SizedBox(width: 7.0),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
