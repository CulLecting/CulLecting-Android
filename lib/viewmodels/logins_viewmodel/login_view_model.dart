import 'package:example_tabbar2/models/user_model.dart';
import 'package:example_tabbar2/screens/logins/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:example_tabbar2/screens/main_screen.dart';
import 'package:example_tabbar2/screens/logins/make_account_screen.dart';
import '../../screens/logins/onboarding_screen.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../providers/user_provider.dart';

class LoginViewModel extends ChangeNotifier {


  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://cullecting.site'));
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final TokenManager _tokenManager = TokenManager();

  // 🔹 TextEditingController 추가
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController verifyController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
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
  bool get isChecked => _isChecked; // 체크박스 토글용
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
        passwordController.text == passwordConfirmController.text &&
        nicknameController.text.isNotEmpty;
  }
  String? get verifyErrorMessage => _verifyErrorMessage;
  String? get verificationToken => _verificationToken;
  String? get passwordErrorMessage => _passwordErrorMessage;
  String? get passwordConditionErrorMessage => _passwordConditionErrorMessage;
  String? get nickLengthErrorMessage => _nickLengthErrorMessage;
  String get timerText =>
      "${_remainingTime.inMinutes.remainder(60).toString()}:${_remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0')}";

  UserProvider? _userProvider;
  LoginViewModel({UserProvider? userProvider}) {
    _userProvider = userProvider;
  }
  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

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

  void validateNickLength() { //닉네임 조건 확인 함수
    final nickname = nicknameController.text;

    if (nickname.length > 12) {
      _nickLengthErrorMessage = "닉네임은 12자 이하로 입력해주세요.";
    } else {
      _nickLengthErrorMessage = null;
    }

    notifyListeners(); // UI 갱신
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

  void navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MakeAccountScreen()), // 회원가입 화면으로 이동
    );
  }

  void navigateToChangePw(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordScreen()), // 회원가입 화면으로 이동
    );
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
    nicknameController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> verifyEmailCallButtonPressed() async { ///이메일 인증요청
    if (_isVerificationInProgress) return null; //isVerificationInProgress가 돌고 있는 한 더블클릭은 방지됨!
    _isEmailVerifyCall = true;
    _isVerificationInProgress = true;
    startTimer();
    print("실행됨");
    notifyListeners();

    try {
      Response response = await _dio.post(
        '/member/email-verifications',
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

  Future<bool> makeAccount(BuildContext context) async { //isverified==true, 비밀번호==비밀번호 확인, 닉네임!=null, isChecked==true이어야함.
    print("토큰: ${_verificationToken}");
    try {
      Response response = await _dio.post(
        '/member',
        data: {"email": emailController.text, "password":newpasswordController.text, "nickname":nicknameController.text},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_verificationToken", // ✅ 토큰 추가
          },
        ),
      );
      print("받은거: ${response.data}");
      if (response.statusCode == 200) {
        _isEmailVerifyCall = true;
        _isVerificationInProgress = false;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) { // ✅ DioException을 캐치
      print("🚨 Dio 오류 발생 🚨");
      print("에러 타입: ${e.type}");
      print("에러 메시지: ${e.message}");
      print("서버 응답: ${e.response?.data}");
      print("서버 상태 코드: ${e.response?.statusCode}");
    } catch (e) {
      print("❌ 일반 오류 발생: $e");
    } finally {
      _isVerificationInProgress = false;
      return false;
    }
  }

  Future<bool> login() async { ///로그인
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.post(
        '/member/login',
        data: {
          "email": idController.text,
          "password": passwordController.text,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );
      print("이메일: ${idController.text}, 비밀번호: ${passwordController.text}");

      if (response.statusCode == 200 && response.data != null) {
        FocusManager.instance.primaryFocus?.unfocus();
        String accessToken = response.data["data"]["accessToken"];
        String refreshToken = response.data["data"]["refreshToken"];

        await _tokenManager.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        _dio.options.headers["Authorization"] = "Bearer $accessToken";

        _isLoading = false;

        _initializeUser();
        notifyListeners();
        print("로그인 성공 토큰: ${response.data}");
        return true; // ✅ 로그인 성공 시 true 반환
      }
    } catch (e) {
      print("로그인 오류: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false; // ✅ 로그인 실패 시 false 반환
  }

  Future<void> _initializeUser() async {
    final token = await _storage.read(key: "accessToken");
    if (token != null) {
      print("시험삼아");
      await _userProvider!.fetchUserFromServer(token);
      print("이름: ${_userProvider!.user.nickname}");
    }
  }

  Future<bool> onboardingLogin() async { ///로그인
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.post(
        '/member/login',
        data: {
          "email": emailController.text,
          "password": newpasswordController.text,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200 && response.data != null) {
        String accessToken = response.data["accessToken"];
        String refreshToken = response.data["refreshToken"];

        await _storage.write(key: "accessToken", value: accessToken);
        await _storage.write(key: "refreshToken", value: refreshToken);

        _dio.options.headers["Authorization"] = "Bearer $accessToken";

        _isLoading = false;
        notifyListeners();

        print("로그인 성공 토큰: ${response.data}");
        return true; // ✅ 로그인 성공 시 true 반환
      }
    } catch (e) {
      print("로그인 오류: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false; // ✅ 로그인 실패 시 false 반환
  }

  void loadOnboardingScreen(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  void loadMainScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  // 📌 로그인 실패 시 다이얼로그 표시 함수
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75, // 🔹 가로 크기 조정 (75% 비율)
            child: IntrinsicHeight( // 🔹 내용에 맞게 높이 자동 조절
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  message,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 팝업 닫기
              },
              child: Text(
                "확인",
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );

      },
    );
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