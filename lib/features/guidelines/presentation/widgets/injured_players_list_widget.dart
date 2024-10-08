import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/guidelines/data/models/injury_model.dart';
import 'package:flutter/material.dart';

Widget injuredPlayerList({required List<InjuryModel> players}) {

  Kit kit = Kit();

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Players ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
            Row(
              children: [
                Text("Chance ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
                SizedBox(width: 20,),
                Text("State ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: 10,),
      ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: players.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                // showModalBottomSheet(
                //     backgroundColor: Colors.transparent,
                //     context: context, builder: (BuildContext context){
                //   return playerStatModalSheet(player: players[index], context: context);
                // });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  color: Color(0xFF1E727E).withOpacity(0.04),
                  child: ListTile(
                    leading: Container(
                      width: 41.79,
                      height: 57.74,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(kit.getKit(team: players[index].injuredPlayer.tabbr, position: players[index].injuredPlayer.role)), fit: BoxFit.fill)
                      ),
                    ),
                    title: Text(players[index].injuredPlayer.pname, style: TextStyle(color: textBlackColor, fontSize: 12, fontWeight: FontWeight.w700),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(players[index].injuredPlayer.role, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w400),),
                        players[index].injury_title == null ? SizedBox() : Text(players[index].injury_title!, style: TextStyle(color: dangerColor, fontSize: 10, fontWeight: FontWeight.w400),),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${players[index].chance}%", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textBlackColor),),
                        SizedBox(width: 24,),
                        Text(players[index].state, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: dangerColor),),
                      ],
                    ),
                  ),
                ),
              ),
            );
          })
    ],
  );
}