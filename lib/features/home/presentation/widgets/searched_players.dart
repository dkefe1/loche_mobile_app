import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/guidelines/data/models/injury_model.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/presentation/widgets/transfer_modal_sheet.dart';
import 'package:flutter/material.dart';

Widget searchedPlayersWidget({required List<EntityPlayer> searchedPlayers, required List<String> myPlayersId, required num budget, required List<MatchModel> matches, required List<InjuryModel> injuredPlayers}) {

  Kit kit = Kit();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Players ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
          Text("Price ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
        ],
      ),
      SizedBox(height: 10,),
      ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: searchedPlayers.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {

            InjuryModel? injury;

            for(int i=0; i<injuredPlayers.length;i++){
              if(injuredPlayers[i].injuredPlayer.pid == searchedPlayers[index].pid){
                injury = injuredPlayers[i];
              }
            }

            return myPlayersId.contains(searchedPlayers[index].pid) ? SizedBox() : GestureDetector(
              onTap: (){
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context, builder: (BuildContext context){
                  return transferModalSheet(player: searchedPlayers[index], context: context, budget: budget, matches: matches);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  color: myPlayersId.contains(searchedPlayers[index].pid) ? Color(0xFF1E727E).withOpacity(0.5) : Color(0xFF1E727E).withOpacity(0.04),
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
                        injury == null ? SizedBox() : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(injury.state, style: TextStyle(color: dangerColor2, fontSize: 10, fontWeight: FontWeight.w400),),
                            SizedBox(width: 5,),
                            Text("${injury.chance}%", style: TextStyle(color: dangerColor2, fontSize: 10, fontWeight: FontWeight.w400),)
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(searchedPlayers[index].price.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),),
                  ),
                ),
              ),
            );
          })
    ],
  );
}