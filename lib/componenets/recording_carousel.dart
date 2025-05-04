import 'package:flutter/material.dart';

class RecordingCarousel extends StatelessWidget {
  final int itemCount;
  final double height;
  final double maxScale;
  final IndexedWidgetBuilder itemBuilder;

  RecordingCarousel({
    required this.itemCount,
    required this.height,
    this.maxScale = 1.0,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(viewportFraction: 0.62); // 👈 좀 더 붙게 조절

    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: controller,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              double value = 1.0;

              if (controller.position.haveDimensions) {
                value = controller.page! - index;
                value = (1 - (value.abs() * 0.25)).clamp(0.7, 1.0); // 👈 좀 더 부드럽게 축소
              } else if (controller.initialPage == index) {
                value = 1.0;
              } else {
                value = 0.9;
              }

              return Center(
                child: Transform.scale(
                  scale: value,
                  child: child,
                ),
              );
            },
            child: itemBuilder(context, index),
          );
        },
      ),
    );
  }
}
