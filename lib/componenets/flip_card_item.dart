import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/card_flip_view_model.dart';
import '../viewmodels/history_view_model.dart'; // HistoryViewModel이 정의된 파일

class FlipCardItem extends StatelessWidget {
  final Widget frontCard;
  final Widget backCard;
  const FlipCardItem({
    Key? key,
    required this.frontCard,
    required this.backCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 플립 애니메이션 관련 뷰모델
    final cardFlipViewModel = context.watch<CardFlipViewModel>();
    // HistoryViewModel에서 관리하는 globalKey
    final historyViewModel = Provider.of<HistoryViewModel>(context, listen: false);

    double angle = cardFlipViewModel.rotationAngle + cardFlipViewModel.animation.value;
    bool isFront = angle % (2 * pi) < pi;

    return RepaintBoundary(
      key: historyViewModel.globalKey, // FlipCard 전체를 감싸는 RepaintBoundary에 globalKey 부여
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(angle),
        child: isFront
            ? frontCard
            : Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: backCard,
        ),
      ),
    );
  }
}
