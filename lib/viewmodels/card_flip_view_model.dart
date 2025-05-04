import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/animation.dart';
import 'dart:math';

class CardFlipViewModel extends ChangeNotifier implements TickerProvider {
  late AnimationController _cardFlipController;
  late Animation<double> _animation;
  double _rotationAngle = 0; // 누적 회전 각도 (라디안 단위)
  bool _isFront = true;

  CardFlipViewModel() {
    _cardFlipController = AnimationController(
      vsync: this, // 뷰모델이 직접 TickerProvider 역할 수행
      duration: Duration(milliseconds: 600),
    );

    _animation = Tween<double>(begin: 0, end: pi).animate(_cardFlipController)
      ..addListener(() {
        notifyListeners();
      });

    _cardFlipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isFront = !_isFront;
        _rotationAngle += pi; // 누적 회전각 업데이트
        _cardFlipController.reset();
        notifyListeners();
      }
    });
  }

  Animation<double> get animation => _animation;
  double get rotationAngle => _rotationAngle;
  bool get isFront => _isFront;

  /// 카드 플립 애니메이션 실행 (매번 0부터 애니메이션 시작)
  void flipCard() {
    _cardFlipController.forward(from: 0.0);
  }

  // TickerProvider 인터페이스 구현 (간단한 Ticker 반환)
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }

  @override
  void dispose() {
    _cardFlipController.dispose();
    super.dispose();
  }
}
