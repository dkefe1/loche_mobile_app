import 'package:cached_network_image/cached_network_image.dart';
import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/time_convert.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/remaining_time.dart';
import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/fixture/presentation/screens/match_detail_screen.dart';
import 'package:flutter/material.dart';

Widget fixtureComponent({required String formattedDate, required List<MatchModel> matches}){

  TimeConvert timeConvert = TimeConvert();

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
        Text(formattedDate, style: TextStyle(color: primaryColor, fontSize: 18),),
        SizedBox(height: 5,),
        Divider(color: borderColor, thickness: 1.0,),
        SizedBox(height: 10,),
        ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: matches.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){

              String matchFormattedDate = timeConvert.formatTimestampToDateTime(int.parse(matches[index].timestampstart));

              return matches[index].status_str == "cancelled" ? SizedBox() : GestureDetector(
                onTap: (){
                  print(matches[index].mid);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MatchDetailScreen(matchId: matches[index].mid, formattedDate: formattedDate, matches: matches[index])));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    matches[index].status == "3" ? Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text("${matches[index].time}'", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10),),
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
                              imageUrl: matches[index].home.logo,
                              placeholder: (context, url) => BlinkContainer(width: 50, height: 50, borderRadius: 50),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            SizedBox(height: 5,),
                            Text(matches[index].home.abbr, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),)
                          ],
                        ),
                        (matches[index].status == "2" || matches[index].status == "3") ? Column(
                          children: [
                            Text("${matches[index].result.home} - ${matches[index].result.away}", style: TextStyle(color: primaryColor, fontSize: 22, fontWeight: FontWeight.w800),),
                            matches[index].status == "3" ? Text("Live", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),) : RemainingTimeWidget(timestamp: int.parse(matches[index].timestampstart)),
                          ],
                        ) : Column(
                          children: [
                            Text(matchFormattedDate, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),),
                            Text("VS", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textBlackColor),),
                            RemainingTimeWidget(timestamp: int.parse(matches[index].timestampstart)),
                          ],
                        ),
                        Column(
                          children: [
                            CachedNetworkImage(
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill,
                              imageUrl: matches[index].away.logo,
                              placeholder: (context, url) => BlinkContainer(width: 50, height: 50, borderRadius: 50),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            SizedBox(height: 5,),
                            Text(matches[index].away.abbr, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),)
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    index == matches.length - 1 ? SizedBox() : Divider(color: borderColor, thickness: 1.0,),
                    index == matches.length - 1 ? SizedBox() : SizedBox(height: 10,),
                  ],
                ),
              );
            }),
      ],
    ),
  );
}