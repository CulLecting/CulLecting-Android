import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:example_tabbar2/screens/main_screen.dart';
import 'package:example_tabbar2/screens/logins/make_account_screen.dart';
import '../../screens/logins/onboarding_screen.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://cullecting.site'));
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final TokenManager _tokenManager = TokenManager();

  // 🔹 TextEditingController 추가
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController verifyController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  // 🔹 상태 관리 변수
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  bool _isChecked = false;
  bool _isMakeAccount = false;
  bool _isLoading = false;
  bool _isEmailVerifyCall = false;
  bool _isVerified = false;
  bool _isVerificationInProgress = false;
  bool _isTimerVisible = false;


  String? _verificationToken;

  //에러 표시용 메시지 변수들 선언
  String? _verifyErrorMessage;
  String? _passwordErrorMessage; // 🔹 비밀번호 확인용 에러 메시지 추가
  String? _passwordConditionErrorMessage;
  String? _nickLengthErrorMessage;



  // 🔹 Getter
  bool get obscurePassword1 => _obscurePassword1; //패스워드 보이고 안보이고
  bool get obscurePassword2 => _obscurePassword2;
  bool get isMakeAccount => _isMakeAccount;
  bool get isLoading => _isLoading;
  bool get isEmailVerifyCall => _isEmailVerifyCall;
  bool get isVerified => _isVerified;
  bool get isVerificationInProgress => _isVerificationInProgress;
  bool get isTimerRunning => _timer != null && _timer!.isActive; //타이머 돌아가고 있는지 확인
  bool get isTimerVisible => _isTimerVisible;
  bool get isButtonEnabled {
    return _isVerified &&
        passwordController.text.isNotEmpty &&
        passwordConfirmController.text.isNotEmpty &&
        passwordController.text == passwordConfirmController.text;
  }
  String? get verifyErrorMessage => _verifyErrorMessage;
  String? get verificationToken => _verificationToken;
  String? get passwordErrorMessage => _passwordErrorMessage;
  String? get passwordConditionErrorMessage => _passwordConditionErrorMessage;
  String get timerText =>
      "${_remainingTime.inMinutes.remainder(60).toString()}:${_remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0')}";




  //타이머 정의
  Duration _remainingTime = Duration(seconds: 180);
  Timer? _timer;
  void startTimer() {
    _verifyErrorMessage = null;
    _isTimerVisible = true;
    _remainingTime = Duration(seconds: 180);
    _timer?.cancel(); // 기존 타이머 취소
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds == 1) {
        _remainingTime -= Duration(seconds: 1);
        timer.cancel();
        _verifyErrorMessage = "인증번호 입력 시간이 만료되었어요";
        statusUpdate();
        // 인증번호 만료 처리 등 추가 가능
      } else {
        _remainingTime -= Duration(seconds: 1);

        notifyListeners();
      }
    });
    notifyListeners();
  }



  void validatePasswordCondition() { //패스워드 조건 확인 함수
    final password = newpasswordController.text;

    // 정규식 검사
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');

    if (!regex.hasMatch(password)) {
      _passwordConditionErrorMessage = "비밀번호는 8자 이상 영문, 숫자, 특수문자를 모두 포함해 주세요";
    } else {
      _passwordConditionErrorMessage = null;
    }

    notifyListeners();
  }

  void validatePassword() { //password확인이랑 서로 일치하는 지 확인
    if (newpasswordController.text.isNotEmpty &&
        passwordConfirmController.text.isNotEmpty) {
      if (newpasswordController.text != passwordConfirmController.text) {
        _passwordErrorMessage = "비밀번호가 일치하지 않아요";
      } else {
        _passwordErrorMessage = null;
      }
    } else {
      _passwordErrorMessage = null; // 입력이 없을 때는 에러 메시지 표시 안 함
    }
    notifyListeners();
  }


  void navigateToLoginScreen(BuildContext context) { //회원가입 창 -> 로그인 창 이동
    Navigator.pop(context); // 현재 화면 닫고 이전 화면으로 이동
  }

  void statusUpdate() { // UI 업데이트용 함수
    notifyListeners();
  }

  // 🔹 비밀번호 가시성 토글
  void togglePasswordVisibility1() {
    _obscurePassword1 = !_obscurePassword1;
    notifyListeners();
  }

  void togglePasswordVisibility2() {
    _obscurePassword2 = !_obscurePassword2;
    notifyListeners();
  }

  // 🔹 개인정보 이용약관 체크박스
  void toggleCheckBox(bool? value) {
    _isChecked = value!; //체크상태 업데이트
    notifyListeners();
  }

  // 🔹 회원가입 화면 토글
  void toggleAccount() {
    _isMakeAccount = !_isMakeAccount;
    notifyListeners();
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    emailController.dispose();
    verifyController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> verifyEmailCallButtonPressed() async { ///이메일 인증요청
    if (_isVerificationInProgress) return null; //isVerificationInProgress가 돌고 있는 한 더블클릭은 방지됨!
    _isEmailVerifyCall = true;
    _isVerificationInProgress = true;
    startTimer();
    notifyListeners();

    try {
      Response response = await _dio.post(
        '/member/password/reset-request',
        data: {"email": emailController.text},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

    } catch (e) {
      print("이메일 인증 오류: $e");
    } finally {
      _isVerificationInProgress = false;
      notifyListeners();
    }
  }

  Future<void> verify() async { ///인증번호 확인하기
    String? code = verifyController.text;
    String? email = emailController.text;
    if (code.isEmpty) {
      _verifyErrorMessage = "인증번호를 입력하십시오.";
      notifyListeners();
      return;
    }

    try {
      Response response = await _dio.post(
        '/member/email-verifications/verify',
        data: {"email": email, "code": code},
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      print("인증결과: ${response.data["message"]}, ${response.statusCode}");

      if (response.statusCode == 200 && response.data["message"] == "이메일 인증 성공") {

        _isVerified = true;
        _verifyErrorMessage = null;
        _verificationToken = response.data["data"]["token"];
        notifyListeners();
        print("인증 완료");

        Fluttertoast.showToast(
          msg: "본인 인증이 완료되었습니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        _verifyErrorMessage = "인증번호가 일치하지 않습니다.";
        notifyListeners();
      }
    } catch (e) {
      _verifyErrorMessage = "인증 과정에서 오류가 발생했습니다.";
      notifyListeners();
    }
  }

  Future<bool> changePassword(BuildContext context) async {
    print("토큰: ${_verificationToken}");
    try {
      // PATCH로 요청하고, 엔드포인트와 파라미터 키를 맞춤.
      final Response response = await _dio.patch(
        '/member/password',
        data: {
          "email": emailController.text,
          "newPassword": newpasswordController.text,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_verificationToken", // 토큰 추가
          },
        ),
      );
      print("받은 데이터: ${response.data}");

      // 응답 status가 200이면 성공으로 처리
      if (response.statusCode == 200) {
        _isEmailVerifyCall = true;
        _isVerificationInProgress = false;
        notifyListeners();
        return true;
      } else {
        // 200이 아닌 경우 실패 처리
        _isVerificationInProgress = false;
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      print("🚨 Dio 오류 발생 🚨");
      print("에러 타입: ${e.type}");
      print("에러 메시지: ${e.message}");
      print("서버 응답: ${e.response?.data}");
      print("서버 상태 코드: ${e.response?.statusCode}");
      _isVerificationInProgress = false;
      notifyListeners();
      return false;
    } catch (e) {
      print("❌ 일반 오류 발생: $e");
      _isVerificationInProgress = false;
      notifyListeners();
      return false;
    }
  }


}


class TokenManager {
  // Flutter Secure Storage 인스턴스 생성
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // 토큰 저장
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  // 토큰 읽기
  Future<Map<String, String?>> getTokens() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    String? refreshToken = await _storage.read(key: 'refreshToken');
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  // 토큰 삭제 (로그아웃 시)
  Future<void> deleteTokens() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }
}