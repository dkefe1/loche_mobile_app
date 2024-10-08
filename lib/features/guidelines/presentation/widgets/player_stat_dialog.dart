import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/guidelines/data/models/player_stat.dart';
import 'package:fantasy/features/guidelines/presentation/screens/player_stat_detail_screen.dart';
import 'package:fantasy/features/home/presentation/widgets/player_detail_component.dart';
import 'package:flutter/material.dart';

Widget playerStatDialog({required PlayerStat player, required BuildContext context}) {

  Kit kit = Kit();

  return Dialog(
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Details", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor),),
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.close, size: 25, color: textBlackColor,))
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 61.03,
            height: 84.33,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(kit.getKit(team: player.club, position: player.position)), fit: BoxFit.fill)
            ),
          ),
          SizedBox(height: 10,),
          Text(player.full_name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textBlackColor),),
          Text(player.position, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: textColor),),
          SizedBox(height: 20,),
          playerDetailComponent(key: "Points", value: player.fantasy_point.toString(), iconImage: "images/rating.png", isNetwork: false),
          SizedBox(height: 20,),
          GestureDetector(
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerStatDetailScreen(clientPlayer: player,)));
              },
              child: Text("More", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),)),
          SizedBox(height: 20,),
        ],
      ),
    ),
  );
}