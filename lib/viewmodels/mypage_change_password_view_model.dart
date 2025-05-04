import 'package:flutter/material.dart';

class mypageChangePasswordViewModel extends ChangeNotifier {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  String? _passwordErrorMessage;
  String? _passwordConditionErrorMessage;

  bool _obscureNew = true;
  bool _obscureConfirm = true;


  bool get obscureNew => _obscureNew;
  bool get obscureConfirm => _obscureConfirm;
  String? get passwordErrorMessage => _passwordErrorMessage;
  String? get passwordConditionErrorMessage => _passwordConditionErrorMessage;


  void toggleNewVisibility() {
    _obscureNew = !_obscureNew;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    _obscureConfirm = !_obscureConfirm;
    notifyListeners();
  }

  void validatePassword() { //password확인이랑 서로 일치하는 지 확인
    if (newPasswordController.text.isNotEmpty &&
        passwordConfirmController.text.isNotEmpty) {
      if (newPasswordController.text != passwordConfirmController.text) {
        _passwordErrorMessage = "비밀번호가 일치하지 않아요";
      } else {
        _passwordErrorMessage = null;
      }
    } else {
      _passwordErrorMessage = null; // 입력이 없을 때는 에러 메시지 표시 안 함
    }
    notifyListeners();
  }

  void validatePasswordCondition() { //패스워드 조건 확인 함수
    final password = newPasswordController.text;

    // 정규식 검사
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');

    if (!regex.hasMatch(password)) {
      _passwordConditionErrorMessage = "비밀번호는 8자 이상 영문, 숫자, 특수문자를 모두 포함해 주세요";
    } else {
      _passwordConditionErrorMessage = null;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }
}
