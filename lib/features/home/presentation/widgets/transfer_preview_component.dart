import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/presentation/widgets/transfer_player_avatar.dart';
import 'package:flutter/material.dart';

Widget transferPreviewComponent({required List<ClientPlayer> players, required List<String> myPlayersId, required String budget, required List<MatchModel> matches}) {
  return Center(
    child: SizedBox(
      height: 86,
      child: ListView.builder(
          itemCount: players.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return transferPlayerAvatar(player: players[index], context: context, myPlayersId: myPlayersId, budget: budget, matches: matches);
          }),
    ),
  );
}