import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:fantasy/features/notification/data/models/notification_model.dart';
import 'package:fantasy/features/notification/presentation/widgets/notification_box.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/pajamas.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);
  
  List<NotificationModel> notifications = [
    NotificationModel(content: "Low credit alert! Deposit now to keep playing and winning.", iconPath: "images/alert.png", isSeen: true, isAlert: true),
    NotificationModel(content: "You have successful deposit a credit to your account. your credit amount is 340coin now.", iconPath: "images/notification3.png", isSeen: true, isAlert: false),
    NotificationModel(content: "You have successful created a team joined the contest,Good luck for your team!", iconPath: "images/notification2.png", isSeen: true, isAlert: false),
    NotificationModel(content: "Congratulations! You've won the jackpot! Get ready to celebrate your victory and enjoy your well-deserved rewards. Keep up the great work!", iconPath: "images/notification1.png", isSeen: false, isAlert: false),
    NotificationModel(content: "You have successful deposit a credit to your account. your credit amount is 340coin now.", iconPath: "images/notification3.png", isSeen: true, isAlert: false),
    NotificationModel(content: "You have successful created a team joined the contest,Good luck for your team!", iconPath: "images/notification2.png", isSeen: false, isAlert: false),
    NotificationModel(content: "Congratulations! You've won the jackpot! Get ready to celebrate your victory and enjoy your well-deserved rewards. Keep up the great work!", iconPath: "images/notification1.png", isSeen: false, isAlert: false),
  ];

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
                title: "Notifications",
                desc:
                "Check out current informations related your actions."),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(defaultBorderRadius))),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.5),
                              child: Iconify(Pajamas.task_done, size: 17, color: primaryColor,),
                            ),
                            SizedBox(width: 6,),
                            Text("Mark all as read", style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.w600),),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                          itemCount: notifications.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return notificationBox(notification: notifications[index]);
                          }),
                      SizedBox(height: 10,)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
