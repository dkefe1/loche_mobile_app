import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/profile/presentation/widgets/scout_modal_sheet.dart';
import 'package:flutter/material.dart';

Widget scoutSearchWidget({required List<EntityPlayer> searchedPlayers, required List<String> scouts}) {

  Kit kit = Kit();

  return Column(
    children: [
      ListView.builder(
          itemCount: searchedPlayers.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return scouts.contains(searchedPlayers[index].pid) ? SizedBox() : GestureDetector(
              onTap: (){
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context, builder: (BuildContext context){
                  return scoutModalSheet(scout: searchedPlayers[index], context: context);
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
                          image: DecorationImage(image: AssetImage(kit.getKit(team: searchedPlayers[index].clubAbbr, position: searchedPlayers[index].position)), fit: BoxFit.fill)
                      ),
                    ),
                    title: Text(searchedPlayers[index].full_name, style: TextStyle(color: textBlackColor, fontSize: 12, fontWeight: FontWeight.w700),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(searchedPlayers[index].position, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w400),),
                        searchedPlayers[index].transfer_radar ? Text("Player in loan/transfer radar", style: TextStyle(color: dangerColor2, fontSize: 10, fontWeight: FontWeight.w400),) : SizedBox(),
                        searchedPlayers[index].is_injuried || searchedPlayers[index].is_banned ? Text("Player in banned/injured list", style: TextStyle(color: dangerColor2, fontSize: 10, fontWeight: FontWeight.w400),) : SizedBox(),
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