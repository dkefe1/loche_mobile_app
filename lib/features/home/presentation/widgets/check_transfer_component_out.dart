import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:flutter/material.dart';

Widget checkTransferComponentOut({required ClientPlayer player, required String title}) {

  Kit kit = Kit();

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),),
      Flexible(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 27.64,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(kit.getKit(team: player.club, position: player.position)), fit: BoxFit.fill)
              ),
            ),
            SizedBox(width: 5,),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: Text(player.full_name, style: TextStyle(fontSize: 12, color: Colors.black, overflow: TextOverflow.ellipsis),)),
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
                        child: Center(child: Text(player.position, style: TextStyle(fontSize: 8, color: Colors.black),)),
                      ),
                      Text(" / ", style: TextStyle(fontSize: 10, color: Colors.black),),
                      Text("LC ${player.price}", style: TextStyle(color: title == "Player Out" ? dangerColor2 : Colors.greenAccent, fontSize: 10),)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )
    ],
  );
}