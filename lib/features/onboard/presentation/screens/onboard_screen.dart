import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/onboard/presentation/widgets/onboard_body1.dart';
import 'package:fantasy/features/onboard/presentation/widgets/onboard_body2.dart';
import 'package:fantasy/features/onboard/presentation/widgets/onboard_body3.dart';
import 'package:fantasy/features/onboard/presentation/widgets/onboard_body4.dart';
import 'package:fantasy/features/onboard/presentation/widgets/onboard_body5.dart';
import 'package:fantasy/features/onboard/presentation/widgets/onboard_body6.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageController = PageController();

  bool isLast = false;

  final prefService = PrefService();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            if (index == 5) {
              setState(() {
                isLast = true;
              });
            } else {
              setState(() {
                isLast = false;
              });
            }
          },
          children: [
            onBoardBody1(h: h, w: w),
            onBoardBody4(h: h, w: w),
            onBoardBody5(h: h, w: w),
            onBoardBody2(h: h, w: w),
            onBoardBody3(h: h, w: w),
            onBoardBody6(h: h, w: w),
          ],
        ),
      ),
      bottomSheet: isLast
          ? TextButton(
              onPressed: () {
                prefService.board();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
              },
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: Size.fromHeight(80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            )
          ),
              child: Text(
                "Get Started",
                style: TextStyle(color: onPrimaryColor),
              ))
          : Container(
              color: backgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        pageController.jumpToPage(5);
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: textFontSize2,
                            fontWeight: FontWeight.w600),
                      )),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 6,
                    effect: WormEffect(
                        dotColor: Color(0xFFD9D9D9),
                        activeDotColor: primaryColor,
                        dotHeight: 8,
                        dotWidth: 8),
                  ),
                  TextButton(
                      onPressed: () {
                        pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeIn);
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: textFontSize2,
                            fontWeight: FontWeight.w600),
                      )),
                ],
              ),
            ),
    );
  }
}
