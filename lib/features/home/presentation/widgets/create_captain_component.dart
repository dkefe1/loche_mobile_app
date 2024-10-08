import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/presentation/widgets/player_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

Widget createCaptainComponent({required String text, required List<EntityPlayer> players, required void Function(String, bool, bool) onTapCaptain, required void Function(String, bool, bool) onTapVice}) {

  Kit kit = Kit();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 12),),
      SizedBox(height: 5,),
      ListView.builder(
        padding: EdgeInsets.zero,
          itemCount: players.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return players[index].isBench ? SizedBox() : GestureDetector(
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
                      players[index].isCaptain ? GestureDetector(
                        onTap: () {
                          onTapCaptain(players[index].pid, false, players[index].isViceCaptain);
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
                      ) :  GestureDetector(
                        onTap: () {
                          onTapCaptain(players[index].pid, true, players[index].isViceCaptain);
                        },
                        child: Iconify(MaterialSymbols.add_circle_outline_rounded, color: primaryColor, size: 30,),
                      ),
                      SizedBox(width: 43,),
                      players[index].isViceCaptain ? GestureDetector(
                        onTap: () {
                          onTapVice(players[index].pid, false, players[index].isCaptain);
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
                      ) :  GestureDetector(
                        onTap: () {
                          onTapVice(players[index].pid, true, players[index].isCaptain);
                        },
                        child: Iconify(MaterialSymbols.add_circle_outline_rounded, color: primaryColor, size: 30,),
                      ),
                      SizedBox(width: 5,)
                    ],
                  ),
                ),
              ),
            );
          })
    ],
  );
}