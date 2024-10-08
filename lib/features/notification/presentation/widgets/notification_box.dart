import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/notification/data/models/notification_model.dart';
import 'package:flutter/material.dart';

Widget notificationBox({required NotificationModel notification}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
        color: notification.isAlert ? dangerBgColor : notification.isSeen ? backgroundColor : lightPrimary,
      border: Border(bottom: BorderSide(color: Color(0xFF1E727E).withOpacity(0.3), width: 1.0))
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Image.asset(
                notification.iconPath,
                fit: BoxFit.fill,
                width: 24.07,
                height: 25,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.content,
                    style: TextStyle(
                      color: notification.isAlert ? onDangerBgColor : notification.isSeen ? textBlackColor : primaryColor,
                      fontSize: textFontSize2,
                    ),
                  ),
                  Text(
                    "2 days ago",
                    style: TextStyle(fontSize: textFontSize, color: textColor),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
