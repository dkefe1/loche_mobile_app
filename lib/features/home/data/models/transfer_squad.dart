import 'package:fantasy/features/guidelines/data/models/injury_model.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';

class TransferSquad{
  final List<EntityPlayer> players;
  final List<InjuryModel> injuredPlayers;

  TransferSquad({required this.players, required this.injuredPlayers});
}