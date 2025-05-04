import 'package:flutter/material.dart';
import '../screens/main_screen.dart';

class OnboardingViewModel extends ChangeNotifier {
  // 선택된 구들을 저장하는 리스트
  final List<String> _selectedCities = [];
  final List<String> _selectedCultures = [];

  bool isSkip = false;


  List<String> get selectedCities => _selectedCities;
  List<String> get selectedCultures => _selectedCultures;

  int selectedCity = 0;
  int selectedCulture = 0;
  int page = 1;

  String buttonText = "다음";

  // 버튼 탭 시 호출될 함수
  void tapCityButton(String buttonName) {
    if (_selectedCities.contains(buttonName)) {
      selectedCity -= 1;
      _selectedCities.remove(buttonName); // 이미 선택된 경우 해제
    } else {
      if (_selectedCities.length >= 3) return; // 3개 초과 시 무시
      selectedCity+=1;
      _selectedCities.add(buttonName); // 새로 선택
    }
    notifyListeners(); // UI 갱신
  }

  void tapCultureButton(String buttonName){
    if (_selectedCultures.contains(buttonName)) {
      selectedCulture -= 1;
      _selectedCultures.remove(buttonName); // 이미 선택된 경우 해제
    } else {
      if (_selectedCultures.length >= 3) return; // 3개 초과 시 무시
      selectedCulture+=1;
      _selectedCultures.add(buttonName); // 새로 선택
    }
    notifyListeners(); // UI 갱신
  }

  void moveNextPage(){
    page +=1;
    if (page==2) buttonText = "다음";
    else if (page==3) buttonText = "시작하기";
    notifyListeners();
  }

  void moveBackPage(){
    page -=1;
    buttonText = "다음";
    notifyListeners();
  }

  void moveEndPage(){
    page = 3;
    buttonText = "시작하기";
    notifyListeners();
  }

  bool isSelectedCity(String buttonName) {
    return _selectedCities.contains(buttonName);
  }

  bool isSelectedCulture(String buttonName) {
    return _selectedCultures.contains(buttonName);
  }

  void loadMainScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }
}
