import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget advIndicator({required int activeIndex, required int count}) {
  return AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: count,
    effect: WormEffect(
        dotColor: Color(0xFFD9D9D9),
        activeDotColor: primaryColor,
        dotHeight: 8,
        dotWidth: 8
    ),
  );
}