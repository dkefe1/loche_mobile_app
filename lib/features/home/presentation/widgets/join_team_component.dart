import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/presentation/widgets/join_team_avatar.dart';
import 'package:flutter/material.dart';

Widget joinTeamComponent({required List<ClientPlayer> players}) {
  return SizedBox(
    height: 86,
    child: ListView.builder(
        itemCount: players.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: joinTeamPlayerAvatar(player: players[index], context: context),
          );
        }),
  );
}