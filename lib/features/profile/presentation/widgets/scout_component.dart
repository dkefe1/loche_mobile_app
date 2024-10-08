import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/profile/data/models/scout.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/widgets/delete_scout_dialog.dart';
import 'package:fantasy/features/profile/presentation/widgets/scoutDetailDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget scoutComponent({required String text, required List<Scout> players}) {

  Kit kit = Kit();

  return players.isEmpty ? SizedBox() : Column(
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
            return GestureDetector(
              onTap: (){
                showDialog(context: context, builder: (context) {
                  return scoutDetailDialog(scout: players[index], context: context);
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
                        image: DecorationImage(image: AssetImage(kit.getKit(team: players[index].team, position: players[index].position)), fit: BoxFit.fill)
                    ),
                  ),
                  title: Text(players[index].player_name, style: TextStyle(color: textBlackColor, fontSize: 12, fontWeight: FontWeight.w700),),
                  subtitle: Text(players[index].position, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w400),),
                  trailing: GestureDetector(
                      onTap: (){
                        showDialog(context: context, builder: (BuildContext context){
                          return deleteScoutDialog(context: context, onPressed: (){
                            final deleteScout = BlocProvider.of<DeleteScoutBloc>(context);
                            deleteScout.add(RemoveScoutEvent(players[index].player_id));
                          }, content: "Are you sure you want to delete this player?");
                        });
                      },
                      child: Icon(Icons.delete, color: dangerColor2,)),
                ),
              ),
            );
          })
    ],
  );
}