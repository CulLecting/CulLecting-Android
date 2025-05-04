import 'package:example_tabbar2/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/edit_info_view_model.dart';
import '../../constant/constants.dart';
import '../../componenets/component.dart';
import 'dart:ui';

class EditInfoScreen extends StatelessWidget {
  const EditInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Color(0xFFFFFFFF),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  top(),
                  const SizedBox(height: 32),
                  middle(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Container(height: 8),
            changePwButton(),
            Container(height: 8),
            logoutButton(),
            Spacer(),
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: leaveButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget top() {
    return Consumer<EditInfoViewModel>(
        builder: (context, viewModel, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => viewModel.navigateToBackPage(context),
              ),
              const Spacer(flex: 2),
              Text(
                '내 정보 수정',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  height: 1.35,
                  letterSpacing: 0.0,
                  color: Color(0xFF2F2F2F),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        );
      }
    );
  }

  Widget middle() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '닉네임',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: Color(0xFF4F4F4F),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 327,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userProvider.user.nickname,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF2F2F2F),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 20,
                      color: Color(0xFF2F2F2F),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => nicknameEditBottomSheet(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '이메일',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: Color(0xFF4F4F4F),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 327,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'cullecti**@naver.com',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF909090),
                    ),
                  ),
                  Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFECE0),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Center(
                      child: Text(
                        '인증 완료',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1.2,
                          color: Color(0xFFFF5401),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget changePwButton(){
    return Consumer<EditInfoViewModel>(
        builder: (context, viewModel, _) {
        return GestureDetector(
          onTap: () {
            viewModel.navigateToChangePw(context);
          },
          child: Container(
            width: double.infinity,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '비밀번호 변경',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
                Icon(Icons.chevron_right, size: 18),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget nicknameEditBottomSheet() {
    return Consumer<EditInfoViewModel>(
      builder: (context, viewModel, _) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 40,
                  height: 4,
                  child: Divider(thickness: 2),
                ),
                const SizedBox(height: 16),
                const Text(
                  '닉네임 변경',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: viewModel.nicknameController,
                  onChanged: (_) => viewModel.validateNickLength(),
                  decoration: defaultInputDecoration(
                    isError: viewModel.nickLengthErrorMessage != null,
                  ),
                ),
                errorBox(
                  interval: 20.0,
                  errorMessage: viewModel.nickLengthErrorMessage,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: viewModel.isNicknameValid
                        ? () {
                      // 버튼을 누르기 전에 활성화된 overlay를 미리 캡처합니다.
                      final overlayState = Overlay.of(context);
                      viewModel.saveNickname(context);
                      // 먼저 현재 페이지를 pop 합니다.
                      Navigator.pop(context);
                      // pop 후, 미리 캡처한 overlayState를 사용해 토스트를 표시합니다.
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (overlayState != null) {
                          showNicknameChangedToastWithOverlay(overlayState);
                        }
                      });
                    }
                        : null,
                    style: undefinedButton,
                    child: const Text('완료', style: TextStyle(fontSize: 16.0)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget logoutButton(){
    return Consumer<EditInfoViewModel>(
        builder: (context, viewModel, _) {
        return GestureDetector(
          onTap: () {
            viewModel.showLogoutDialog(context);
          },
          child: Container(
            width: double.infinity,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color: Colors.white,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '로그아웃',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFF2F2F2F),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget leaveButton() {
    return Consumer<EditInfoViewModel>(
        builder: (context, viewModel, _) {
        return TextButton(
          onPressed: () {
            viewModel.navigateToLeave(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF6F6F6F), // 텍스트 색상
            padding: EdgeInsets.zero, // 기본 패딩 제거 (필요 시)
            minimumSize: Size.zero, // 크기 최소화 (필요 시)
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 터치 영역 최소화
          ),
          child: const Text(
            '탈퇴하기',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.35,
            ),
          ),
        );
      }
    );
  }

  void showNicknameChangedToastWithOverlay(OverlayState overlayState) {
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 56 + MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xCC888888),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white, size: 24),
                    SizedBox(width: 16),
                    Text(
                      '닉네임 변경이 완료되었습니다',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.35,
                        color: Color(0xFFFCFCFC),
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

    overlayState.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }



}
