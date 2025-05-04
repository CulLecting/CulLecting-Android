import 'package:example_tabbar2/screens/mypage/mypage_change_password_screen.dart';
import 'package:example_tabbar2/screens/mypage/leave_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/logins/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class EditInfoViewModel extends ChangeNotifier {
  final TextEditingController nicknameController = TextEditingController();
  String? _nickLengthErrorMessage;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Dio _dio = Dio();

  String? get nickLengthErrorMessage => _nickLengthErrorMessage;

  /// 닉네임 유효성 체크: 1자 이상 & 12자 이하
  bool get isNicknameValid =>
      nicknameController.text.trim().isNotEmpty &&
          nicknameController.text.trim().length <= 12;

  EditInfoViewModel(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // 초기 닉네임 설정
    // UserProvider의 변경을 구독하여 텍스트 필드 업데이트 (텍스트 필드가 포커스되어 있지 않을 때만)
    userProvider.addListener(() {
      final newNickname = userProvider.user.nickname;
      // 만약 텍스트 필드가 편집 중이 아니라면(즉, 포커스되어 있지 않다면) 업데이트
      if (!(nicknameController.selection.baseOffset > -1 &&
          FocusScope.of(context).hasFocus)) {
        if (nicknameController.text != newNickname) {
          nicknameController.text = newNickname;
        }
      }
    });

    // 닉네임 컨트롤러 변경 리스너 추가
    nicknameController.addListener(() {
      validateNickLength();
      notifyListeners();
    });
  }

  void validateNickLength() {
    final nickname = nicknameController.text.trim();

    if (nickname.length > 12) {
      _nickLengthErrorMessage = "닉네임은 12자 이하로 입력해주세요.";
    } else {
      _nickLengthErrorMessage = null;
    }
  }

  void navigateToBackPage(BuildContext context) {
    Navigator.pop(context);
  }

  void navigateToChangePw(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const mypageChangePasswordScreen()),
    );
  }

  void navigateToLeave(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeaveScreen()),
    );
  }

  /// 닉네임 저장: UserProvider의 닉네임도 업데이트
  // 이미 초기화된 UserProvider 인스턴스를 사용합니다.
  void saveNickname(BuildContext context) {
    final newNickname = nicknameController.text.trim();

    // Provider.of<UserProvider>를 이용해 이미 생성된 인스턴스를 가져옵니다.
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    userProvider.updateNickname(newNickname);
    nicknameUpdate(context);
    print("닉네임 저장됨: $newNickname");
    // 이 notifyListeners()는 updateNickname 내부에서 호출되므로 다시 호출할 필요는 없습니다.
  }

  Future<void> nicknameUpdate(BuildContext context) async {
    final String newNickname = nicknameController.text.trim();
    if (newNickname.isEmpty) {
      print("닉네임이 비어있습니다.");
      return;
    }

    // secure storage에서 token 읽어오기
    final String? token = await _storage.read(key: "accessToken");
    if (token == null) {
      print("Access token not found.");
      return;
    }

    try {
      Response response = await _dio.patch(
        "https://cullecting.site/member/nickname",
        data: {"nickname": newNickname},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        print("닉네임 업데이트 성공: ${response.data}");
        // 서버 업데이트가 성공하면 UserProvider를 통해 전역 사용자 데이터도 업데이트합니다.
        final userProvider =
        Provider.of<UserProvider>(context, listen: false);
        userProvider.updateNickname(newNickname);
      } else {
        print("서버 오류: ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      print("닉네임 업데이트 중 에러 발생: $e");
    }
  }


  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: const Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: Text(
                    '로그아웃 하시겠어요?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFFFEFEFE),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text("취소", style: TextStyle(color: Colors.black),),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5401),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text("로그아웃", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }
}
