import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/logins_viewmodel/login_view_model.dart';
import '../../constant/constants.dart';
import 'package:example_tabbar2/componenets/component.dart';

class MakeAccountScreen extends StatelessWidget {
  final double _interval = 25.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: showMakeAccount()),
    );
  }

  Widget showMakeAccount() {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 5.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed:
                        () => loginViewModel.navigateToLoginScreen(
                          context,
                        ), // ✅ 뷰모델 함수 호출
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  Spacer(flex: 2),
                  Text(
                    "가입하기",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Spacer(flex: 3),
                ],
              ),
            ),
            SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    Row(
                      // 이메일 입력 필드 + 인증 요청 버튼
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: defaultInputDecoration(hintText: "이메일"),
                            enabled:
                                !loginViewModel.isVerified, // 인증 성공 시 입력 비활성화
                            controller: loginViewModel.emailController,
                            onChanged: (_) => loginViewModel.statusUpdate(),
                          ),
                        ),

                        if (!loginViewModel.isVerified) ...[
                          SizedBox(width: 10),
                          SizedBox(
                            width: 90.0,
                            child: ElevatedButton(
                              onPressed:
                                  loginViewModel.emailController.text.isNotEmpty
                                      ? () async {
                                        await loginViewModel
                                            .verifyEmailCallButtonPressed(); // 이메일 인증 API 호출 (뷰모델 내 메서드)
                                      }
                                      : null,
                              style: blackElevatedButton,
                              child: FittedBox(
                                fit: BoxFit.none,
                                child:
                                    loginViewModel.isEmailVerifyCall
                                        ? Text(
                                          "재전송",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                        : Text(
                                          "인증 요청",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: _interval),

                    // 인증번호 입력
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: loginViewModel.verifyController,
                            enabled:
                                !loginViewModel.isVerified, // 인증 성공 시 입력 비활성화
                            onChanged: (_) => loginViewModel.statusUpdate(),
                            decoration: defaultInputDecoration(
                              hintText: "인증번호 입력 (3분 이내)",
                              isError:
                                  loginViewModel.verifyErrorMessage != null,
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 12, top: 15.0),
                                child:
                                    loginViewModel.isTimerVisible
                                        ? Text(
                                          loginViewModel.timerText,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                        : null,
                              ),
                            ),
                          ),
                        ),
                        if (!loginViewModel.isVerified) ...[
                          // ✅ 버튼과 여백을 묶어서 조건부 렌더링
                          SizedBox(width: 10),
                          SizedBox(
                            width: 90.0,
                            child: ElevatedButton(
                              onPressed:
                                  loginViewModel
                                          .verifyController
                                          .text
                                          .isNotEmpty
                                      ? () async {
                                        await loginViewModel.verify();
                                        loginViewModel.statusUpdate();
                                      }
                                      : null,
                              style: blackElevatedButton,
                              child: FittedBox(
                                fit: BoxFit.none,
                                child: Text(
                                  "인증 완료",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    errorBox(
                      interval: _interval,
                      errorMessage: loginViewModel.verifyErrorMessage,
                    ),

                    // 비밀번호 입력 (뷰모델의 passwordController, obscurePassword1 사용)
                    TextField(
                      controller: loginViewModel.newpasswordController,
                      obscureText: loginViewModel.obscurePassword1,
                      onChanged: (_) {
                        loginViewModel.validatePassword();
                        loginViewModel.validatePasswordCondition();
                      },
                      decoration: defaultInputDecoration(
                        isError:
                            loginViewModel.passwordConditionErrorMessage !=
                            null,
                        hintText: "비밀번호",
                        suffixIcon: IconButton(
                          icon: Icon(
                            loginViewModel.obscurePassword1
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey[700],
                          ),
                          onPressed: () {
                            loginViewModel.togglePasswordVisibility1();
                          },
                        ),
                      ),
                    ),
                    errorBox(
                      interval: _interval,
                      errorMessage:
                          loginViewModel.passwordConditionErrorMessage,
                    ),

                    // 비밀번호 확인 (passwordConfirmController, obscurePassword2)
                    TextField(
                      controller: loginViewModel.passwordConfirmController,
                      obscureText: loginViewModel.obscurePassword2,
                      onChanged: (_) => loginViewModel.validatePassword(),
                      decoration: defaultInputDecoration(
                        hintText: "비밀번호 확인",
                        isError: loginViewModel.passwordErrorMessage != null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            loginViewModel.obscurePassword2
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey[700],
                          ),
                          onPressed: () {
                            loginViewModel.togglePasswordVisibility2();
                          },
                        ),
                      ),
                    ),
                    errorBox(
                      interval: _interval,
                      errorMessage: loginViewModel.passwordErrorMessage,
                    ),

                    // 닉네임 입력 (뷰모델의 nicknameController 사용)
                    TextField(
                      controller: loginViewModel.nicknameController,
                      onChanged: (_) => loginViewModel.validateNickLength(),
                      decoration: defaultInputDecoration(
                        hintText: "닉네임",
                        isError: loginViewModel.nickLengthErrorMessage != null,
                      ),
                    ),
                    errorBox(
                      interval: _interval,
                      errorMessage: loginViewModel.nickLengthErrorMessage,
                    ),
                    // 개인정보 이용약관 동의 체크박스
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            loginViewModel.toggleCheckBox(
                              !loginViewModel.isChecked,
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.radio_button_unchecked,
                                size: 24,
                                color:
                                    loginViewModel.isChecked
                                        ? Colors.orange
                                        : Colors.black,
                              ),
                              Icon(
                                Icons.check,
                                size: 13,
                                color:
                                    loginViewModel.isChecked
                                        ? Colors.orange
                                        : Colors.black,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          "가입 약관에 모두 동의합니다.",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey, // 글자색 (회색)
                          ),
                          child: Text(
                            "확인하기",
                            style: TextStyle(
                              fontSize: 14, // 글자 크기 (작게 설정)
                              decoration: TextDecoration.underline, // 밑줄 추가
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 회원가입 버튼 (회원가입 로직을 추가하세요)
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ElevatedButton(
                        onPressed:
                            loginViewModel.isButtonEnabled
                                ? () async {
                                  bool isSuccess = await loginViewModel.makeAccount(context);
                                  if (isSuccess){
                                    loginViewModel.onboardingLogin();
                                    loginViewModel.loadOnboardingScreen(context);
                                  }
                                 }
                                : null,
                        style: blackElevatedButton, //constant.dart에 저장되있음
                        child: Text("다음"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
