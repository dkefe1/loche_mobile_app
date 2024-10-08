import 'package:fantasy/features/home/data/models/entity_player.dart';

class EntityClub {
  final String abbr;
  final String logo;
  final List<EntityPlayer> entityPlayer;

  EntityClub({required this.abbr, required this.logo, required this.entityPlayer});

}