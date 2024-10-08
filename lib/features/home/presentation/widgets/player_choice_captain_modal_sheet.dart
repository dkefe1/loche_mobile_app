import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/widgets/bottom_modal_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget playerChoiceCaptainModalSheet({required EntityPlayer player, required BuildContext context}) {
  return IntrinsicHeight(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: modalBottomColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(60))
      ),
      child: Consumer<SelectedPlayersProvider>(
        builder: (context, data, child) {
          return Column(
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
              player.isBench ? SizedBox() : player.isCaptain ? SizedBox() : bottomModalComponent(icon: "C", value: "Make Captain", onPressed: (){
                if (player.isViceCaptain) {
                  errorFlashBar(
                      context: context,
                      message:
                      "Player can not be both captain and vice captain");
                  return;
                }
                data.selectCaptain(id: player.pid);
                Navigator.pop(context);
              }),
              (player.isCaptain || player.isViceCaptain) ? SizedBox() : SizedBox(height: 15,),
              player.isBench ? SizedBox() : player.isViceCaptain ? SizedBox() : bottomModalComponent(icon: "V", value: "Make Vice Captain", onPressed: (){
                if (player.isCaptain) {
                  errorFlashBar(
                      context: context,
                      message:
                      "Player can not be both captain and vice captain");
                  return;
                }
                data.selectViceCaptain(id: player.pid);
                Navigator.pop(context);
              }),
              SizedBox(height: 25,),
            ],
          );
        }
      ),
    ),
  );
}