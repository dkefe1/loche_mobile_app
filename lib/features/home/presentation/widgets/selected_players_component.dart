import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/widgets/player_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:provider/provider.dart';

Widget selectedPlayersComponent({required int selectedTab}) {
  return Consumer<SelectedPlayersProvider>(
    builder: (context, data, child) {

      Kit kit = Kit();

      List<EntityPlayer> players = [];

      List<EntityPlayer> gkPlayers = data.selectedPlayers.where((player) => player.position == "Goalkeeper").toList();
      List<EntityPlayer> defPlayers = data.selectedPlayers.where((player) => player.position == "Defender").toList();
      List<EntityPlayer> midPlayers = data.selectedPlayers.where((player) => player.position == "Midfielder").toList();
      List<EntityPlayer> forPlayers = data.selectedPlayers.where((player) => player.position == "Forward").toList();

      if (selectedTab == 0) {
        players = gkPlayers;
      } else if (selectedTab == 1) {
        players = defPlayers;
      } else if (selectedTab == 2) {
        players = midPlayers;
      } else {
        players = forPlayers;
      }

      return players.isEmpty ? SizedBox() : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Selected Players",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor),
          ),
          SizedBox(
            height: 5,
          ),
          ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: players.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    showDialog(context: context, builder: (context) {
                      return playerDetailDialog(player: players[index], context: context);
                    });
                  },
                  child: Container(
                    color: Color(0xFF1E727E).withOpacity(0.04),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 41.79,
                        height: 57.74,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage(kit.getKit(team: players[index].clubAbbr, position: players[index].position)), fit: BoxFit.fill)
                        ),
                      ),
                      title: Text(players[index].full_name, style: TextStyle(color: textBlackColor, fontSize: 12, fontWeight: FontWeight.w700),),
                      subtitle: Text(players[index].position, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w400),),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(players[index].price.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),),
                          SizedBox(width: 20,),
                          GestureDetector(
                            onTap: () {
                              data.removePlayer(players[index]);
                              data.increaseCredit(double.parse(players[index].price));
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              child: Iconify(Ic.round_done_all, color: onPrimaryColor,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      );
    }
  );
}