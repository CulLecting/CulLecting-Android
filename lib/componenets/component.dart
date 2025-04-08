import 'package:flutter/material.dart';

Widget errorBox ({
  double? interval,
  String? errorMessage
}) {
  return SizedBox(
    height: interval,
    child: errorMessage != null
        ? Padding(
      padding: const EdgeInsets.only(left: 12.0), // ✅ 왼쪽 여백만 줌
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          errorMessage!,
          style: TextStyle(color: Colors.red, fontSize: 12),
          textAlign: TextAlign.left,
        ),
      ),
    )
        : SizedBox.shrink(),
  );
}

Widget onboardingButton({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 156,
      height: 43,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFECE0) : const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isSelected ? const Color(0xFFFF5401) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected ? const Color(0xFFFF5401) : const Color(0xFF2F2F2F),
        ),
      ),
    ),
  );
}

