import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:fantasy/features/notification/presentation/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

class AppHeader extends StatelessWidget {

  String title, desc;

  AppHeader({Key? key, required this.title, required this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              title.isNotEmpty ? Text(title, style: TextStyle(color: onPrimaryColor, fontWeight: FontWeight.w700, fontSize: 14),) : logoName(),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
              //   },
              //   child: Container(
              //     width: 27,
              //     height: 27,
              //     child: Stack(
              //       children: [
              //         Iconify(
              //           Ic.outline_notifications,
              //           size: 27,
              //           color: Colors.white,
              //         ),
              //         Container(
              //           width: 27,
              //           height: 27,
              //           alignment: Alignment.topRight,
              //           margin: EdgeInsets.only(top: 5),
              //           child: Container(
              //             margin: EdgeInsets.fromLTRB(0, 2, 2, 0),
              //             width: 10,
              //             height: 10,
              //             decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 color: dangerColor2,
              //                 border: Border.all(color: Colors.white, width: 1)),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
          desc.isEmpty ? SizedBox() : SizedBox(
            height: 10,
          ),
          desc.isEmpty ? SizedBox() : Text(
            desc,
            style: TextStyle(
                color: onPrimaryColor,
                fontWeight: FontWeight.w400,
                fontSize: textFontSize),
          )
        ],
      ),
    );
  }
}
