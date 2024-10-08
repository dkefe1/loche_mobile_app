import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/presentation/widgets/player_avatar.dart';
import 'package:flutter/material.dart';

Widget previewComponent2({required List<ClientPlayer> players, required bool isSwitch}) {
  return SizedBox(
    height: 86,
    child: ListView.builder(
        itemCount: players.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: playerAvatar(player: players[index], context: context,  isSwitch: isSwitch),
          );
        }),
  );
}