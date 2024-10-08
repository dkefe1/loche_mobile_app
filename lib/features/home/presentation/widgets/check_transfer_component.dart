import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:flutter/material.dart';

Widget checkTransferComponent({required EntityPlayer playerIn,required ClientPlayer playerOut, required String titleIn, required String titleOut}) {

  Kit kit = Kit();

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Text(titleIn, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),),
          SizedBox(height: 20,),
          Text(titleOut, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),),
          SizedBox(height: 22,),
          Text("Cost", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),),
        ],
      ),
      SizedBox(width: 10,),
      Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 27.64,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(kit.getKit(team: playerIn.clubAbbr, position: playerIn.position)), fit: BoxFit.fill)
                    ),
                  ),
                  SizedBox(width: 5,),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(child: Text(playerIn.full_name, style: TextStyle(fontSize: 12, color: Colors.black, overflow: TextOverflow.ellipsis),)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 18,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(child: Text(playerIn.position, style: TextStyle(fontSize: 8, color: Colors.black),)),
                            ),
                            Text(" / ", style: TextStyle(fontSize: 10, color: Colors.black),),
                            Text("LC ${playerIn.price}", style: TextStyle(color: Colors.greenAccent, fontSize: 10),)
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 27.64,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(kit.getKit(team: playerOut.club, position: playerIn.position)), fit: BoxFit.fill)
                    ),
                  ),
                  SizedBox(width: 5,),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(child: Text(playerOut.full_name, style: TextStyle(fontSize: 12, color: Colors.black, overflow: TextOverflow.ellipsis),)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 18,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(child: Text(playerOut.position, style: TextStyle(fontSize: 8, color: Colors.black),)),
                            ),
                            Text(" / ", style: TextStyle(fontSize: 10, color: Colors.black),),
                            Text("LC ${playerOut.price}", style: TextStyle(color: dangerColor2, fontSize: 10),)
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Text("${(playerOut.price - num.parse(playerIn.price)).toStringAsFixed(1)} LC", style: TextStyle(color: playerOut.price - num.parse(playerIn.price) >= 0 ? Colors.greenAccent : dangerColor2, fontWeight: FontWeight.w600, fontSize: 16),),
          ],
        ),
      )
    ],
  );
}