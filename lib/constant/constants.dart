import 'package:flutter/material.dart';

const Shadow myShadow = Shadow(
  offset: Offset(-5.0, 5.0),
  blurRadius: 5.0,
  color: Colors.black12,
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
  //비활성화 됐을 때 글자만 비활성화 되는 버튼 스타일
  backgroundColor: Colors.grey[300],
  foregroundColor: Colors.black,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
);

final ButtonStyle undefinedButton = ButtonStyle(
  animationDuration: Duration.zero,
  backgroundColor: MaterialStateProperty.resolveWith<Color>((
    Set<MaterialState> states,
  ) {
    return const Color(0xFF2F2F2F); // 🔹 항상 동일한 배경색
  }),
  foregroundColor: MaterialStateProperty.resolveWith<Color>((
    Set<MaterialState> states,
  ) {
    if (states.contains(MaterialState.disabled)) {
      return const Color(0xFFB0B0B0); // 🔸 비활성화 시 텍스트 색
    }
    return Colors.white; // 🔹 활성화 시 텍스트 색
  }),
  minimumSize: MaterialStateProperty.all(const Size(327, 56)),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  ),
);

InputDecoration defaultInputDecoration({
  int? radius,
  String? hintText,
  String? labelText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  bool isError = false,
  EdgeInsets? contentPadding, // ✅ 추가
}) {
  final double resolvedRadius = (radius ?? 20).toDouble();

  return InputDecoration(
    filled: true,
    fillColor: Colors.grey[200],
    hintText: hintText,
    labelText: labelText,
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 16), // ✅ 기본값 설정
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(resolvedRadius),
      borderSide: isError ? const BorderSide(color: Colors.red) : BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(resolvedRadius),
      borderSide: isError ? const BorderSide(color: Colors.red) : BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(resolvedRadius),
      borderSide: isError ? const BorderSide(color: Colors.red) : BorderSide.none,
    ),
  );
}


BoxDecoration toogleBoxDecoration(bool istrue) {
  return istrue
      ? BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: const Color(0xFFFFD1B3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD1B3).withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      )
      : BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.transparent),
      );
}

TextStyle get menuTextStyle => TextStyle(
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w500,
  fontSize: 16,
  height: 1.35, // line-height (폰트 사이즈의 배수)
  letterSpacing: 0,
  color: Colors.white, // 텍스트 색상 (원하는 색상으로 조정)
  backgroundColor: const Color(0xFF2F2F2F), // 배경색
);

