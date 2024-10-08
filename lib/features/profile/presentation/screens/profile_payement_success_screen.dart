import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:fantasy/features/index.dart';
import 'package:flutter/material.dart';

class ProfilePaymentSuccessScreen extends StatefulWidget {

  bool isPackage;
  ProfilePaymentSuccessScreen({Key? key, required this.isPackage}) : super(key: key);

  @override
  State<ProfilePaymentSuccessScreen> createState() => _ProfilePaymentSuccessScreenState();
}

class _ProfilePaymentSuccessScreenState extends State<ProfilePaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
    GestureDetector(
        onPanUpdate: (details) async {
          if (details.delta.dx > 30) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IndexScreen(pageIndex: 2,)));
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: primaryScreen(),
        )
    )
        : WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IndexScreen(pageIndex: 2,)));
        return false;
      },
      child: primaryScreen(),
    );
  }

  Widget primaryScreen(){
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appHeader2(
                title: "Payment Completed",
                desc:
                widget.isPackage ? "You have successfully purchased a package. Check your profile" : "You have successfully deposited your credit. Check your profile"),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(defaultBorderRadius))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/success.png", fit: BoxFit.fill, width: 80, height: 80,),
                    SizedBox(height: 20,),
                    Text("Payment Completed!", style: TextStyle(color: textBlackColor, fontWeight: FontWeight.w600, fontSize: 14),),
                    SizedBox(height: 10,),
                    Text(widget.isPackage ? "You have successfully purchased a package. Check your profile" : "You have successfully deposited your credit. Check your profile", textAlign: TextAlign.center, style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 13),),
                    SizedBox(height: 40,),
                    SizedBox(
                        width: double.infinity,
                        child:
                        submitButton(onPressed: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => IndexScreen(pageIndex: 2,)), (route) => false);
                        }, text: "Check your profile", disabled: false)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
