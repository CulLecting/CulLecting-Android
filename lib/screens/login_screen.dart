import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  // 예시로 사용중인 InputDecoration
  final defaultInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [showLogin()],
        ),
      ),
    );
  }

  /// 로그인 화면 위젯
  Widget showLogin() {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  children: [
                    Spacer(flex: 3),
                    Text(
                      // 로고 텍스트
                      "CulLecting",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        shadows: [Shadow(blurRadius: 4, offset: Offset(2, 2))],
                      ),
                    ),
                    Spacer(flex: 2),
                    // 비회원으로 구경하기
                    TextButton(
                      onPressed: () {
                        // 비회원 구경 관련 로직
                      },
                      child: Text("둘러보기"),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  Text(
                    "로그인",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 80.0,),

                  // 이메일 입력 필드 (뷰모델의 idController 사용)
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: loginViewModel.idController,
                    decoration: defaultInputDecoration.copyWith(hintText: "이메일"),
                  ),
                  SizedBox(height: 15),

                  // 비밀번호 입력 필드 (뷰모델의 passwordController, obscurePassword1 사용)
                  TextField(
                    controller: loginViewModel.passwordController,
                    obscureText: loginViewModel.obscurePassword1,
                    decoration: defaultInputDecoration.copyWith(
                      hintText: "비밀번호",
                      suffixIcon: IconButton(
                        icon: Icon(
                          loginViewModel.obscurePassword1
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          loginViewModel.togglePasswordVisibility1();
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      TextButton(
                        onPressed: () {
                        },
                        child: Text("비밀번호 재설정 >"),
                      ),
                    ],
                  ),

                  // 로그인 버튼
                  ElevatedButton(
                    onPressed:
                        loginViewModel.isLoading
                            ? null
                            : () async {
                              bool isSuccess = await loginViewModel.login();
                              isSuccess
                                  ? loginViewModel.loadMainScreen(context)
                                  : loginViewModel.showErrorDialog(
                                    context,
                                    "비밀번호가 일치하지 않습니다.",
                                  );
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child:
                        loginViewModel.isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("로그인"),
                  ),
                ],
              ),
              SizedBox(height: 100.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("아직 회원이 아니신가요?"),
                  TextButton(
                    onPressed: () {
                      loginViewModel.navigateToSignUp(context);
                    },
                    child: Text("회원가입"),
                  ),
                ],
              ),

              //sh990920@gmail.com / test
            ],
          ),
        );
      },
    );
  }
}
