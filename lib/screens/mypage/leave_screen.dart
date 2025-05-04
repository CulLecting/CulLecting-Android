import 'package:example_tabbar2/viewmodels/leave_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant/constants.dart';

class LeaveScreen extends StatelessWidget {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ⬅️ 뒤로가기 버튼
              const SizedBox(height: 16),
              backButton(),
              const SizedBox(height: 20),

              // 📸 탈퇴 주의 이미지
              Container(
                width: double.infinity,
                height: 310,
                child: Image.asset(
                  'asset/image/leave_confirm.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 300),

              // ✅ 체크박스 및 문구
              checkBox(),
              SizedBox(height: 20),
              // 🧨 탈퇴하기 버튼
              leaveButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget backButton() {
    return Consumer<LeaveViewModel>(
        builder: (context, viewModel, child) {
        return IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 24,
          padding: EdgeInsets.zero, // 아이콘 주변 여백 제거
          constraints: const BoxConstraints(
            minWidth: 24,
            minHeight: 24,
          ),
          onPressed: () {
            viewModel.navigateToBackPage(context);
          },
        );
      }
    );
  }

  Widget checkBox() {
    return Consumer<LeaveViewModel>(
        builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: () {
            viewModel.toggleCheckBox(
              !viewModel.isChecked,
            );
          },
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.radio_button_unchecked,
                    size: 24,
                    color:
                    viewModel.isChecked
                        ? Colors.orange
                        : Colors.black,
                  ),
                  Icon(
                    Icons.check,
                    size: 13,
                    color:
                    viewModel.isChecked
                        ? Colors.orange
                        : Colors.black,
                  ),

                ],
              ),
              SizedBox(width: 10),
              const Text(
                '위 사실을 확인했습니다.',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.35, // 135%
                  color: Color(0xFF4F4F4F),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget leaveButton() {
    return Consumer<LeaveViewModel>(
      builder: (context, viewModel, child) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: viewModel.isChecked
                ? () {
              viewModel.showLeaveDialog(context); // 🔥 여기서 context 전달
            }
                : null,
            style: undefinedButton,
            child: const Text(
              '탈퇴하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
