import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:fantasy/features/home/presentation/widgets/joined_game_week_modal.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';

class GameWeekHeader extends StatelessWidget {

  String title, desc;
  String gameWeek, total_fantasy_point, gameWeekId;

  GameWeekHeader({Key? key, required this.title, required this.desc, required this.gameWeek, required this.total_fantasy_point, required this.gameWeekId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context, builder: (BuildContext context){
                return joinedGameWeekModalSheet(context: context, gameWeekId: gameWeekId);
              });
            },
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        title.isNotEmpty ? Text(title, style: TextStyle(color: onPrimaryColor, fontWeight: FontWeight.w700, fontSize: 14),) : logoName(),
                      ],
                    ),
                    desc.isEmpty ? SizedBox() : SizedBox(
                      height: 10,
                    ),
                    desc.isEmpty ? SizedBox() : Text(
                      desc,
                      style: TextStyle(
                          color: onPrimaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: textFontSize),
                    )
                  ],
                ),
                SizedBox(width: 5,),
                Iconify(IconParkSolid.down_one, color: Colors.white, size: 30,)
              ],
            ),
          ),
          Text("GW $gameWeek FP : $total_fantasy_point", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),)
        ],
      ),
    );
  }
}
