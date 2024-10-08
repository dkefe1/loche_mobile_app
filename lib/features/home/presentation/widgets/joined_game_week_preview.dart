import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/presentation/widgets/joined_player_avatar.dart';
import 'package:flutter/material.dart';

Widget joinedGameWeekPreview({required List<ClientPlayer> players}) {
  return SizedBox(
    height: 86,
    child: ListView.builder(
        itemCount: players.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return joinedPlayerAvatar(player: players[index], context: context);
        }),
  );
}