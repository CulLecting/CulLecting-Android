import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/mypage_change_password_view_model.dart';
import '../../providers/user_provider.dart';
import '../../constant/constants.dart';
import '../../componenets/component.dart';

class mypageChangePasswordScreen extends StatelessWidget {
  const mypageChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Top(),
            passwords(),
            Expanded(child: Container()),
            confirmButton(),
            SizedBox(height: 20.0,)
          ],
        ),
      ),
    );
  }

  Widget Top() {
    return Consumer<mypageChangePasswordViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 10.0
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed:
                        () =>Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  SizedBox(width: 15.0),
                  Spacer(flex: 1),
                  Text(
                    "비밀번호 변경",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Spacer(flex: 2),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget passwords() {
    return Consumer<mypageChangePasswordViewModel>(
        builder: (context, viewModel, _) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [



              Text('기존 비밀번호'),
              SizedBox(height: 8),
              TextField(
                controller: viewModel.currentPasswordController,
                obscureText: true,
                decoration: defaultInputDecoration(
                  hintText: "기존 비밀번호 입력"
                )
              ),
              SizedBox(height: 24),

              // 새 비밀번호
              Text('새 비밀번호'),
              SizedBox(height: 8),
              TextField(
                controller: viewModel.newPasswordController,
                obscureText: viewModel.obscureNew,
                onChanged: (_) {
                  viewModel.validatePassword();
                  viewModel.validatePasswordCondition();
                },
                decoration: defaultInputDecoration(
                  isError: viewModel.passwordConditionErrorMessage != null,
                  hintText: '숫자, 영문, 특수문자 8자 이상 입력',
                  suffixIcon: IconButton(
                    icon: Icon(viewModel.obscureNew
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: viewModel.toggleNewVisibility,
                  ),
                ),
              ),
              errorBox(interval: 20, errorMessage: viewModel.passwordConditionErrorMessage),


              // 비밀번호 확인 (passwordConfirmController, obscurePassword2)
              Text('새 비밀번호 확인'),
              SizedBox(height: 8),
              TextField(
                controller: viewModel.passwordConfirmController,
                obscureText: viewModel.obscureConfirm,
                onChanged: (_) => viewModel.validatePassword(),
                decoration: defaultInputDecoration(
                  hintText: '비밀번호를 한번 더 입력해 주세요',
                  isError: viewModel.passwordErrorMessage != null,
                  suffixIcon: IconButton(
                    icon: Icon(viewModel.obscureConfirm
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: viewModel.toggleConfirmVisibility,
                  ),
                ),
              ),
              errorBox(interval: 20, errorMessage: viewModel.passwordErrorMessage),

            ],
          ),
        );
      }
    );
  }

  Widget confirmButton(){
    return ElevatedButton(
        onPressed: null,
        style: undefinedButton,
        child: Text("설정 완료")
    );
  }

}
