import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/widgets/game_week_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeAppHeader extends StatelessWidget {

  GameWeek? gameWeek;
  String budget;
  String totalFantasyPoint;
  String gameWeekFantasyPoint;
  bool isLoading;

  HomeAppHeader({Key? key, required this.gameWeek, required this.budget, required this.isLoading, required this.totalFantasyPoint, required this.gameWeekFantasyPoint}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    GameWeek? gameWeek;
    gameWeek = this.gameWeek;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              if(!isLoading){
                final joinedGameWeek =
                BlocProvider.of<JoinedGameWeekBloc>(context);
                joinedGameWeek.add(GetJoinedGameWeekEvent());
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context, builder: (BuildContext context){
                  return gameWeekModalSheet(context: context, gameWeekId: gameWeek?.id);
                });
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    logoName(),
                    SizedBox(height: 5,),
                    Text("${AppLocalizations.of(context)!.game_week} ${gameWeek == null ? "" : gameWeek.game_week}", style: TextStyle(color: onPrimaryColor, fontWeight: FontWeight.w700, fontSize: 14),)
                  ],
                ),
                SizedBox(width: 5,),
                Iconify(IconParkSolid.down_one, color: Colors.white, size: 30,)
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isLoading ? Column(
                children: [
                  BlinkContainer(width: 100, height: 20, borderRadius: 0),
                  SizedBox(height: 5,),
                  BlinkContainer(width: 100, height: 20, borderRadius: 0),
                  SizedBox(height: 5,),
                  BlinkContainer(width: 100, height: 20, borderRadius: 0),
                ],
              ) : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("${AppLocalizations.of(context)!.budget} : $budget LC", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),),
                    Text("${AppLocalizations.of(context)!.total_fp} : $totalFantasyPoint", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),),
                    Text("${AppLocalizations.of(context)!.gw} ${gameWeek == null ? "" : gameWeek.game_week} ${AppLocalizations.of(context)!.fp} : $gameWeekFantasyPoint", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
