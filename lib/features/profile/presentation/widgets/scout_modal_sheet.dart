import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/presentation/widgets/bottom_modal_component.dart';
import 'package:fantasy/features/profile/data/models/scout.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/widgets/scoutDetailDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget scoutModalSheet({required EntityPlayer scout, required BuildContext context}) {
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
                child: Text(scout.position.toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),),
              ),
              SizedBox(width: 10,),
              Text(scout.full_name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),),
            ],
          ),
          SizedBox(height: 20,),
          bottomModalComponent(icon: Ion.md_information, value: AppLocalizations.of(context)!.player_information_g, onPressed: (){
            showDialog(context: context, builder: (context) {
              return scoutDetailDialog(scout: Scout(player_id: scout.pid, player_name: scout.full_name, player_number: "3", position: scout.position, team: scout.clubAbbr, club_logo: scout.club_logo), context: context);
            });
          }),
          SizedBox(height: 15,),
          BlocConsumer<PostScoutBloc, PostScoutState>(builder: (_, state){
            if(state is PostScoutLoadingState){
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white,),
                  ),
                  SizedBox(width: 15,),
                  Text(AppLocalizations.of(context)!.add_to_scout, style: TextStyle(color: Colors.white, fontSize: 16),)
                ],
              );
            }
            return bottomModalComponent(icon: GameIcons.binoculars, value: AppLocalizations.of(context)!.add_to_scout, onPressed: (){
              final postScout = BlocProvider.of<PostScoutBloc>(context);
              postScout.add(CreateScoutEvent(Scout(player_id: scout.pid, player_name: scout.full_name, player_number: "3", position: scout.position, team: scout.clubAbbr, club_logo: scout.club_logo)));
            });
          }, listener: (_, state){
            if (state is PostScoutSuccessfulState) {
              final getScouts = BlocProvider.of<ScoutsBloc>(context);
              getScouts.add(GetAllScoutsEvent());
              Navigator.pop(context);
              Navigator.pop(context);
            } else if (state is PostScoutFailedState) {
              errorFlashBar(context: context, message: state.error);
            }
          }),
          SizedBox(height: 15,),
        ],
      ),
    ),
  );
}