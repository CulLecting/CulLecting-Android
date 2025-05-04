import 'package:flutter/cupertino.dart';
import '../screens/logins/login_screen.dart';
import 'package:flutter/material.dart';

class LeaveViewModel extends ChangeNotifier {

  bool _isChecked = false;

  bool get isChecked => _isChecked;

  void toggleCheckBox(bool value) {
    _isChecked = value; //체크상태 업데이트
    notifyListeners();
  }

  void navigateToBackPage(BuildContext context) {
    Navigator.pop(context);
  }

  void showLeaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          width: 350,
          height: 180,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "계정이 삭제되었습니다",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text("아쉽지만 다음에 또 만나요"),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    "확인",
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
