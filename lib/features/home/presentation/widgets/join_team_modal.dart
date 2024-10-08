import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/presentation/widgets/bottom_modal_component.dart';
import 'package:fantasy/features/home/presentation/widgets/clientPlayerDetailDialog.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/ion.dart';

Widget joinTeamModalSheet({required ClientPlayer player, required BuildContext context}) {
  return IntrinsicHeight(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: modalBottomColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(60))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: SizedBox(width: 80, child: Divider(color: Colors.white, thickness: 3.0,),),),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(60)
                ),
                child: Text(player.position == "Goalkeeper" ? "GK" : player.position.substring(0, 3).toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),),
              ),
              SizedBox(width: 10,),
              Flexible(child: Text(player.full_name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16, overflow: TextOverflow.ellipsis),)),
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(player.price.toString(), style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w600, fontSize: 14),),
              )
            ],
          ),
          SizedBox(height: 20,),
          bottomModalComponent(icon: Ion.md_information, value: "Player Information", onPressed: (){
            Navigator.pop(context);
            showDialog(context: context, builder: (context) {
              return clientPlayerDetailDialog(player: player, context: context);
            });
          }),
          SizedBox(height: 15,),
        ],
      ),
    ),
  );
}