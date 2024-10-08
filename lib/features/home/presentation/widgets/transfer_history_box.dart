import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/core/services/time_convert.dart';
import 'package:fantasy/features/home/data/models/transfer_history.dart';
import 'package:flutter/material.dart';

Widget transferHistoryBox({required TransferHistory transferHistory}){

  Kit kit = Kit();
  TimeConvert timeConvert = TimeConvert();

  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 10),
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    decoration: BoxDecoration(
      color: lightPrimary,
      borderRadius: BorderRadius.circular(15)
    ),
    child: Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Player In", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w700, fontSize: 14),),
                    SizedBox(height: 5,),
                    Image.asset("images/in_icon.png"),
                    SizedBox(height: 5,),
                    Container(
                      width: 41.79,
                      height: 57.74,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(kit.getKit(team: transferHistory.bought_player.club, position: "")), fit: BoxFit.fill)
                      ),
                    ),
                    SizedBox(height: 10,),
                    Expanded(child: Text(transferHistory.bought_player.full_name, style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),)),
                    Text(transferHistory.bought_player.price.toString(), style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              SizedBox(width: 5,),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: 1,
                color: dividerColor,
              ),
              SizedBox(width: 5,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Player Out", style: TextStyle(color: dangerColor2, fontWeight: FontWeight.w700, fontSize: 14),),
                    SizedBox(height: 5,),
                    Image.asset("images/out_icon.png",),
                    SizedBox(height: 5,),
                    Container(
                      width: 41.79,
                      height: 57.74,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(kit.getKit(team: transferHistory.sold_player.club, position: "")), fit: BoxFit.fill)
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(transferHistory.sold_player.full_name, style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                    Text(transferHistory.sold_player.price.toString(), style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(color: dividerColor, thickness: 1.0,),
        SizedBox(height: 5,),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text("Total Cost:", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),),
                    SizedBox(height: 5,),
                    Divider(color: dividerColor, thickness: 1.0,),
                    SizedBox(height: 5,),
                    Text("Date:", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),),
                  ],
                ),
              ),
              SizedBox(width: 5,),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                width: 1,
                color: dividerColor,
              ),
              SizedBox(width: 5,),
              Expanded(
                child: Column(
                  children: [
                    Text((transferHistory.sold_player.price - transferHistory.bought_player.price).toStringAsFixed(1), style: TextStyle(color: (transferHistory.sold_player.price - transferHistory.bought_player.price) >= 0 ? Colors.greenAccent : dangerColor2, fontWeight: FontWeight.w600, fontSize: 16),),
                    SizedBox(height: 5,),
                    Divider(color: dividerColor, thickness: 1.0,),
                    SizedBox(height: 5,),
                    Text(timeConvert.formatDateTime(DateTime.parse(transferHistory.createdAt).add(Duration(hours: 3))), style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}