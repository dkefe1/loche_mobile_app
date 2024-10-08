import 'package:cached_network_image/cached_network_image.dart';
import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/time_convert.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/remaining_time.dart';
import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:flutter/material.dart';

Widget matchInfoComponent({required String formattedDate, required MatchModel matches}){

  TimeConvert timeConvert = TimeConvert();

  String matchFormattedDate = timeConvert.formatTimestampToDateTime(int.parse(matches.timestampstart));

  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 20),
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
    decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(15)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            matches.status == "3" ? Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Text("${matches.time}'", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10),),
            ) : SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CachedNetworkImage(
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                      imageUrl: matches.home.logo,
                      placeholder: (context, url) => BlinkContainer(width: 50, height: 50, borderRadius: 50),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    SizedBox(height: 5,),
                    Text(matches.home.abbr, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),)
                  ],
                ),
                (matches.status == "2" || matches.status == "3") ? Column(
                  children: [
                    Text("${matches.result.home} - ${matches.result.away}", style: TextStyle(color: primaryColor, fontSize: 22, fontWeight: FontWeight.w800),),
                    matches.status == "3" ? Text("Live", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),) : RemainingTimeWidget(timestamp: int.parse(matches.timestampstart)),
                  ],
                ) : Column(
                  children: [
                    Text(matchFormattedDate, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),),
                    Text("VS", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textBlackColor),),
                    RemainingTimeWidget(timestamp: int.parse(matches.timestampstart)),
                  ],
                ),
                Column(
                  children: [
                    CachedNetworkImage(
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                      imageUrl: matches.away.logo,
                      placeholder: (context, url) => BlinkContainer(width: 50, height: 50, borderRadius: 50),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    SizedBox(height: 5,),
                    Text(matches.away.abbr, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),)
                  ],
                )
              ],
            ),
          ],
        )
      ],
    ),
  );
}