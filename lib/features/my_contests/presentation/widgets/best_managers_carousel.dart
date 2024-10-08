import 'package:carousel_slider/carousel_slider.dart';
import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/advert_indicator.dart';
import 'package:fantasy/features/my_contests/presentation/widgets/best_manager_widget.dart';
import 'package:flutter/material.dart';

class BestManagerCarousel extends StatefulWidget {
  const BestManagerCarousel({Key? key}) : super(key: key);

  @override
  State<BestManagerCarousel> createState() => _BestManagerCarouselState();
}

class _BestManagerCarouselState extends State<BestManagerCarousel> {

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(advContainerRadius),
          child: CarouselSlider.builder(
              itemCount: 4,
              itemBuilder: (context, index, realIndex) {
                return bestManagerWidget();
              },
              options: CarouselOptions(
                  height: 260,
                  viewportFraction: 1,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  }
              )),
        ),
        SizedBox(height: 10,),
        Center(child: advIndicator(activeIndex: activeIndex, count: 4)),
        SizedBox(height: 10,),
      ],
    );
  }
}
