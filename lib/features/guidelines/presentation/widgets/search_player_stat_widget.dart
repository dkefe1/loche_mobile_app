import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/stat_kit.dart';
import 'package:fantasy/features/guidelines/data/models/player_stat.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/player_stat_modal.dart';
import 'package:fantasy/features/home/presentation/widgets/transfer_modal_sheet.dart';
import 'package:flutter/material.dart';

Widget searchedPlayerStatWidget({required List<PlayerStat> searchedPlayers}) {

  StatKit kit = StatKit();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Players ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
          Text("Points ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
        ],
      ),
      SizedBox(height: 10,),
      ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: searchedPlayers.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context, builder: (BuildContext context){
                  return playerStatModalSheet(player: searchedPlayers[index], context: context);
                });
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
                          image: DecorationImage(image: AssetImage(kit.getStatKit(team: searchedPlayers[index].club, position: searchedPlayers[index].position)), fit: BoxFit.fill)
                      ),
                    ),
                    title: Text(searchedPlayers[index].full_name, style: TextStyle(color: textBlackColor, fontSize: 12, fontWeight: FontWeight.w700),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(searchedPlayers[index].position, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w400),),
                      ],
                    ),
                    trailing: Text(searchedPlayers[index].fantasy_point.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),),
                  ),
                ),
              ),
            );
          })
    ],
  );
}