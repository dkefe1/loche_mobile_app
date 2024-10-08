import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:fantasy/features/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentSuccessScreen extends StatelessWidget {
  PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                "Thank you for your participation! Good Luck on your contest."),
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
                    Text("Congratulations on your successful payment!. Now you have joined the competition. Thank you for choosing us! and We wish you good luck!", textAlign: TextAlign.center, style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 13),),
                    SizedBox(height: 40,),
                    SizedBox(
                        width: double.infinity,
                        child:
                        submitButton(onPressed: () {
                          final removePlayers = Provider.of<SelectedPlayersProvider>(context, listen: false);
                          removePlayers.removeAllPlayers();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IndexScreen(pageIndex: 0,)));
                        }, text: "Go To My Team", disabled: false)),
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
