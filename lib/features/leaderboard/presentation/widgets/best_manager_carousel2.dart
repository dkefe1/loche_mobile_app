import 'package:carousel_slider/carousel_slider.dart';
import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/advert_indicator.dart';
import 'package:fantasy/features/leaderboard/data/models/winner.dart';
import 'package:fantasy/features/leaderboard/presentation/widgets/best_manager_widget2.dart';
import 'package:flutter/material.dart';

class BestManagerCarousel2 extends StatefulWidget {

  List<Winner> winners;
  final String text;

  BestManagerCarousel2({Key? key, required this.winners, required this.text}) : super(key: key);

  @override
  State<BestManagerCarousel2> createState() => _BestManagerCarousel2State();
}

class _BestManagerCarousel2State extends State<BestManagerCarousel2> {

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget.winners.isEmpty ? SizedBox() : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        SizedBox(height: 10,),
        ClipRRect(
          borderRadius: BorderRadius.circular(advContainerRadius),
          child: CarouselSlider.builder(
              itemCount: widget.winners.length,
              itemBuilder: (context, index, realIndex) {
                return bestManagerWidget2(index: index, winner: widget.winners[index]);
              },
              options: CarouselOptions(
                  height: 140,
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
        Center(child: advIndicator(activeIndex: activeIndex, count: widget.winners.length)),
        SizedBox(height: 10,),
      ],
    );
  }
}
