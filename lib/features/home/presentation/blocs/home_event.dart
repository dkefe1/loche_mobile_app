import 'package:fantasy/features/home/data/models/create_player_model.dart';
import 'package:fantasy/features/home/data/models/create_team_model.dart';
import 'package:fantasy/features/home/data/models/transfer_player.dart';

abstract class AdvertisementEvent {}

class GetAdvertisementEvent extends AdvertisementEvent {
  final String adPackage;
  GetAdvertisementEvent(this.adPackage);
}

abstract class SquadEvent {}

class GetSquadEvent extends SquadEvent {}

abstract class TransferSquadEvent {}

class GetTransferSquadEvent extends TransferSquadEvent {}

abstract class CoachEvent {}

class GetCoachEvent extends CoachEvent {}

abstract class CreateTeamEvent {}

class PostTeamEvent extends CreateTeamEvent {
  final CreateTeamModel createTeamModel;
  PostTeamEvent(this.createTeamModel);
}

abstract class TeamNameEvent {}

class CheckTeamNameEvent extends TeamNameEvent {
  final String teamName;
  CheckTeamNameEvent(this.teamName);
}

abstract class ClientTeamEvent {}

class GetClientTeamEvent extends ClientTeamEvent {}

abstract class SwitchPlayerEvent {}

class PatchSwitchPlayerEvent extends SwitchPlayerEvent {
  final String playerToBeIn, playerToBeOut;
  PatchSwitchPlayerEvent(this.playerToBeIn, this.playerToBeOut);
}

abstract class TransferPlayerEvent {}

class PatchTransferPlayerEvent extends TransferPlayerEvent {
  final String playerToBeOut;
  final TransferPlayerModel transferPlayerModel;
  PatchTransferPlayerEvent(this.playerToBeOut, this.transferPlayerModel);
}

abstract class SwapPlayerEvent {}

class PatchSwapPlayerEvent extends SwapPlayerEvent {
  final String playerToBeIn, playerToBeOut;
  PatchSwapPlayerEvent(this.playerToBeIn, this.playerToBeOut);
}

abstract class GameWeekEvent {}

class GetGameWeekEvent extends GameWeekEvent {}

abstract class JoinedGameWeekTeamEvent {}

class GetJoinedGameWeekTeamEvent extends JoinedGameWeekTeamEvent {}

abstract class JoinGameWeekTeamEvent {}

class PostJoinGameWeekTeamEvent extends JoinGameWeekTeamEvent {
  final String cid;
  PostJoinGameWeekTeamEvent(this.cid);
}

abstract class TransferHistoryEvent {}

class GetTransferHistoryEvent extends TransferHistoryEvent {
  final String page;
  GetTransferHistoryEvent(this.page);
}

abstract class JoinedGameWeekEvent {}

class GetJoinedGameWeekEvent extends JoinedGameWeekEvent {}

abstract class AppVersionEvent {}

class GetAppVersionEvent extends AppVersionEvent {
  final String platformType;
  GetAppVersionEvent(this.platformType);
}

abstract class ActiveGameWeekEvent {}

class GetActiveGameWeekEvent extends ActiveGameWeekEvent {}

abstract class MyCoachEvent {}

class GetMyCoachEvent extends MyCoachEvent {
  final String coachId;
  final bool useLocal;
  GetMyCoachEvent(this.coachId, this.useLocal);
}

abstract class JoinedClientGameWeekEvent {}

class GetJoinedClientGameWeekEvent extends JoinedClientGameWeekEvent {
  final String gameWeekId;
  GetJoinedClientGameWeekEvent(this.gameWeekId);
}

abstract class PatchTeamEvent {}

class UpdateTeamEvent extends PatchTeamEvent {
  final String favorite_coach, favorite_tactic, teamId;
  UpdateTeamEvent(this.favorite_coach, this.favorite_tactic, this.teamId);
}

abstract class ResetTeamEvent {}

class PatchResetTeamEvent extends ResetTeamEvent {}

abstract class RecreateTeamEvent {}

class PatchRecreateTeamEvent extends RecreateTeamEvent {
  final List<CreatePlayerModel> players;
  PatchRecreateTeamEvent(this.players);
}

abstract class TransferModelEvent {}

class GetTransferModelEvent extends TransferModelEvent {}