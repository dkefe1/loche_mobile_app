import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/player_selection_stat_modal.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/home/presentation/widgets/joined_game_week_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';

class PlayerSelectedStatHeader extends StatelessWidget {

  String title;
  GameWeek? gameWeek;

  PlayerSelectedStatHeader({Key? key, required this.title, required this.gameWeek}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: GestureDetector(
        onTap: (){
          final doneGameWeek =
          BlocProvider.of<DoneGameWeekBloc>(context);
          doneGameWeek.add(GetDoneGameWeekEvent());
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context, builder: (BuildContext context){
            return playerSelectionStatModalSheet(context: context, gameWeekId: gameWeek == null ? "all" : gameWeek!.id);
          });
        },
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                logoName(),
                SizedBox(height: 5,),
                Text(gameWeek == null ? "All Time Stat" : "GW ${gameWeek!.game_week} Stat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),)
              ],
            ),
            SizedBox(width: 5,),
            Iconify(IconParkSolid.down_one, color: Colors.white, size: 30,)
          ],
        ),
      ),
    );
  }
}
