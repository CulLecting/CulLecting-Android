import 'package:flutter/material.dart';

const Shadow myShadow = Shadow(
  offset: Offset(-5.0, 5.0),
  blurRadius: 5.0,
  color:  Colors.black12,
);

/// ✅ 공통 ElevatedButton 스타일
final ButtonStyle blackElevatedButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.black, // 🔹 배경색
  foregroundColor: Colors.white, // 🔹 텍스트 & 아이콘 색상
  minimumSize: const Size(double.infinity, 50), // 🔹 버튼 크기 (가로 전체, 높이 50)
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0), // 🔹 버튼의 둥근 모서리
  ),
);

final ButtonStyle confirmElevatedButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey[300],
  foregroundColor: Colors.black,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);

InputDecoration defaultInputDecoration({
  String? hintText,
  String? labelText,
  String? errorText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  bool isError = false,
}) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey[200],
    hintText: hintText,
    labelText: labelText,
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: isError
          ? BorderSide(color: Colors.red)
          : BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: isError
          ? BorderSide(color: Colors.red)
          : BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: isError
          ? BorderSide(color: Colors.red)
          : BorderSide.none,
    ),
  );
}