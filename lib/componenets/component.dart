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


Widget myPageButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 327,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: Color(0xFF2F2F2F)),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 1.35,
                  color: Color(0xFF2F2F2F),
                ),
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF2F2F2F)),
        ],
      ),
    ),
  );
}

Widget bottomSheetText(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 13.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
    ),
  );
}


Widget handle(){
  return Container(
    width: 40,
    height: 4,
    decoration: BoxDecoration(
      color: Colors.grey[400],
      borderRadius: BorderRadius.circular(2),
    ),
  );
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 156,
        height: 43,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFECE0) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(100),
          border: isSelected
              ? Border.all(color: const Color(0xFFFF5401))
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFFFF5401) : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
