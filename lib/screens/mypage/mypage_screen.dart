import 'package:flutter/material.dart';
import '../../componenets/component.dart';
import '../../viewmodels/mypage_view_model.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Consumer<MyPageViewModel>(
        builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          body: Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Top(),
                const SizedBox(height: 40),
                myPageButton(
                  icon: Icons.notifications_none,
                  label: '공지사항',
                  onTap: () => viewModel.navigateAnn(context)
                ),
                const SizedBox(height: 12),
                myPageButton(
                  icon: Icons.question_answer_outlined,
                  label: '자주 묻는 질문',
                  onTap: () {
                    Navigator.pushNamed(context, '/faq');
                  },
                ),
                const SizedBox(height: 12),
                myPageButton(
                  icon: Icons.check_circle_outline,
                  label: '약관 및 정책',
                  onTap: () {
                    Navigator.pushNamed(context, '/policy');
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget Top() {
    return Consumer2<MyPageViewModel, UserProvider>(
        builder: (context, viewModel, userProvider, child) {
          final nickname = userProvider.user.nickname;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$nickname님",
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    height: 1.35, // line-height: 135%
                    letterSpacing: 0.0,
                    color: Color(0xFF2F2F2F), // background → 글자색 처리
                  ),
                ),
                SizedBox(height: 10.0,),

                Text(
                  '내 정보 수정',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 1.35,
                    letterSpacing: 0.0,
                    color: Color(0xFF909090),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF2F2F2F)),
              onPressed: () {
                viewModel.navigateToEditInfo(context); //내 정보 수정으로 이동
              },
            ),
          ],
        );
      }
    );
  }
}
