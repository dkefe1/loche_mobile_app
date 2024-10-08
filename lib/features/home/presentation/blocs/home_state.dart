import 'package:fantasy/features/home/data/models/ClientGameWeekTeam.dart';
import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:fantasy/features/home/data/models/app_update.dart';
import 'package:fantasy/features/home/data/models/client_team_model.dart';
import 'package:fantasy/features/home/data/models/coach.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/home/data/models/joined_client_game_week_team.dart';
import 'package:fantasy/features/home/data/models/joined_game_week_team.dart';
import 'package:fantasy/features/home/data/models/transfer_history.dart';
import 'package:fantasy/features/home/data/models/transfer_model.dart';
import 'package:fantasy/features/home/data/models/transfer_squad.dart';

abstract class AdvertisementState {}

class GetAdvertisementInitialState extends AdvertisementState {}

class GetAdvertisementSuccessfulState extends AdvertisementState {
  final List<Advertisement> content;
  GetAdvertisementSuccessfulState(this.content);
}

class GetAdvertisementFailedState extends AdvertisementState {
  final String error;
  GetAdvertisementFailedState(this.error);
}

class GetAdvertisementLoadingState extends AdvertisementState {}

abstract class SquadState {}

class GetSquadInitialState extends SquadState {}

class GetSquadLoadingState extends SquadState {}

class GetSquadSuccessfulState extends SquadState {
  final List<EntityPlayer> players;
  GetSquadSuccessfulState(this.players);
}

class GetSquadFailedState extends SquadState {
  final String error;
  GetSquadFailedState(this.error);
}

abstract class CoachState {}

class GetCoachInitialState extends CoachState {}

class GetCoachLoadingState extends CoachState {}

class GetCoachSuccessfulState extends CoachState {
  final List<Coach> coaches;
  GetCoachSuccessfulState(this.coaches);
}

class GetCoachFailedState extends CoachState {
  final String error;
  GetCoachFailedState(this.error);
}

abstract class CreateTeamState {}

class CreateTeamInitialState extends CreateTeamState {}

class CreateTeamLoadingState extends CreateTeamState {}

class CreateTeamSuccessfulState extends CreateTeamState {}

class CreateTeamFailedState extends CreateTeamState {
  final String error;
  CreateTeamFailedState(this.error);
}

abstract class TeamNameState {}

class TeamNameInitialState extends TeamNameState {}

class TeamNameLoadingState extends TeamNameState {}

class TeamNameSuccessfulState extends TeamNameState {
  final bool isAvailable;
  TeamNameSuccessfulState(this.isAvailable);
}

class TeamNameFailedState extends TeamNameState {
  final String error;
  TeamNameFailedState(this.error);
}

abstract class ClientTeamState {}

class ClientTeamInitialState extends ClientTeamState {}

class ClientTeamLoadingState extends ClientTeamState {}

class ClientTeamSuccessfulState extends ClientTeamState {
  final ClientTeam team;
  ClientTeamSuccessfulState(this.team);
}

class ClientTeamFailedState extends ClientTeamState {
  final String error;
  ClientTeamFailedState(this.error);
}

abstract class SwitchPlayerState {}

class SwitchPlayerInitialState extends SwitchPlayerState {}

class SwitchPlayerLoadingState extends SwitchPlayerState {}

class SwitchPlayerSuccessfulState extends SwitchPlayerState {}

class SwitchPlayerFailedState extends SwitchPlayerState {
  final String error;
  SwitchPlayerFailedState(this.error);
}

abstract class TransferPlayerState {}

class TransferPlayerInitialState extends TransferPlayerState {}

class TransferPlayerLoadingState extends TransferPlayerState {}

class TransferPlayerSuccessfulState extends TransferPlayerState {}

class TransferPlayerFailedState extends TransferPlayerState {
  final String error;
  TransferPlayerFailedState(this.error);
}

abstract class SwapPlayerState {}

class SwapPlayerInitialState extends SwapPlayerState {}

class SwapPlayerLoadingState extends SwapPlayerState {}

class SwapPlayerSuccessfulState extends SwapPlayerState {}

class SwapPlayerFailedState extends SwapPlayerState {
  final String error;
  SwapPlayerFailedState(this.error);
}

abstract class GameWeekState {}

class GetGameWeekInitialState extends GameWeekState {}

class GetGameWeekLoadingState extends GameWeekState {}

class GetGameWeekSuccessfulState extends GameWeekState {
  final List<GameWeek> gameWeeks;
  GetGameWeekSuccessfulState(this.gameWeeks);
}

class GetGameWeekFailedState extends GameWeekState {
  final String error;
  GetGameWeekFailedState(this.error);
}

abstract class JoinedGameWeekTeamState {}

class GetJoinedGameWeekTeamInitialState extends JoinedGameWeekTeamState {}

class GetJoinedGameWeekTeamLoadingState extends JoinedGameWeekTeamState {}

class GetJoinedGameWeekTeamSuccessfulState extends JoinedGameWeekTeamState {
  final JoinedGameWeekTeam joinedGameWeekTeam;
  GetJoinedGameWeekTeamSuccessfulState(this.joinedGameWeekTeam);
}

class GetJoinedGameWeekTeamFailedState extends JoinedGameWeekTeamState {
  final String error;
  GetJoinedGameWeekTeamFailedState(this.error);
}

abstract class JoinGameWeekTeamState {}

class PostJoinGameWeekTeamInitialState extends JoinGameWeekTeamState {}

class PostJoinGameWeekTeamLoadingState extends JoinGameWeekTeamState {}

class PostJoinGameWeekTeamSuccessfulState extends JoinGameWeekTeamState {}

class PostJoinGameWeekTeamFailedState extends JoinGameWeekTeamState {
  final String error;
  PostJoinGameWeekTeamFailedState(this.error);
}

abstract class TransferHistoryState {}

class GetTransferHistoryInitialState extends TransferHistoryState {}

class GetTransferHistorySuccessfulState extends TransferHistoryState {
  final List<TransferHistory> content;
  GetTransferHistorySuccessfulState(this.content);
}

class GetTransferHistoryFailedState extends TransferHistoryState {
  final String error;
  GetTransferHistoryFailedState(this.error);
}

class GetTransferHistoryLoadingState extends TransferHistoryState {}

abstract class JoinedGameWeekState {}

class GetJoinedGameWeekInitialState extends JoinedGameWeekState {}

class GetJoinedGameWeekSuccessfulState extends JoinedGameWeekState {
  final List<ClientGameWeekTeam> joinedGameWeeks;
  GetJoinedGameWeekSuccessfulState(this.joinedGameWeeks);
}

class GetJoinedGameWeekFailedState extends JoinedGameWeekState {
  final String error;
  GetJoinedGameWeekFailedState(this.error);
}

class GetJoinedGameWeekLoadingState extends JoinedGameWeekState {}

abstract class AppVersionState {}

class GetAppVersionInitialState extends AppVersionState {}

class GetAppVersionSuccessfulState extends AppVersionState {
  final AppUpdate? appUpdate;
  GetAppVersionSuccessfulState(this.appUpdate);
}

class GetAppVersionFailedState extends AppVersionState {
  final String error;
  GetAppVersionFailedState(this.error);
}

class GetAppVersionLoadingState extends AppVersionState {}

abstract class ActiveGameWeekState {}

class GetActiveGameWeekInitialState extends ActiveGameWeekState {}

class GetActiveGameWeekSuccessfulState extends ActiveGameWeekState {
  final GameWeek? activeGameWeek;
  GetActiveGameWeekSuccessfulState(this.activeGameWeek);
}

class GetActiveGameWeekFailedState extends ActiveGameWeekState {
  final String error;
  GetActiveGameWeekFailedState(this.error);
}

class GetActiveGameWeekLoadingState extends ActiveGameWeekState {}

abstract class MyCoachState {}

class GetMyCoachInitialState extends MyCoachState {}

class GetMyCoachSuccessfulState extends MyCoachState {
  final Coach coach;
  GetMyCoachSuccessfulState(this.coach);
}

class GetMyCoachFailedState extends MyCoachState {
  final String error;
  GetMyCoachFailedState(this.error);
}

class GetMyCoachLoadingState extends MyCoachState {}

abstract class JoinedClientGameWeekState {}

class GetJoinedClientGameWeekInitialState extends JoinedClientGameWeekState {}

class GetJoinedClientGameWeekSuccessfulState extends JoinedClientGameWeekState {
  final JoinedClientGameWeekTeam team;
  GetJoinedClientGameWeekSuccessfulState(this.team);
}

class GetJoinedClientGameWeekFailedState extends JoinedClientGameWeekState {
  final String error;
  GetJoinedClientGameWeekFailedState(this.error);
}

class GetJoinedClientGameWeekLoadingState extends JoinedClientGameWeekState {}

abstract class PatchTeamState {}

class PatchTeamInitialState extends PatchTeamState {}

class PatchTeamSuccessfulState extends PatchTeamState {}

class PatchTeamFailedState extends PatchTeamState {
  final String error;
  PatchTeamFailedState(this.error);
}

class PatchTeamLoadingState extends PatchTeamState {}

abstract class ResetTeamState {}

class ResetTeamInitialState extends ResetTeamState {}

class ResetTeamSuccessfulState extends ResetTeamState {}

class ResetTeamFailedState extends ResetTeamState {
  final String error;
  ResetTeamFailedState(this.error);
}

class ResetTeamLoadingState extends ResetTeamState {}

abstract class RecreateTeamState {}

class RecreateTeamInitialState extends RecreateTeamState {}

class RecreateTeamLoadingState extends RecreateTeamState {}

class RecreateTeamSuccessfulState extends RecreateTeamState {}

class RecreateTeamFailedState extends RecreateTeamState {
  final String error;
  RecreateTeamFailedState(this.error);
}

abstract class TransferSquadState {}

class GetTransferSquadInitialState extends TransferSquadState {}

class GetTransferSquadLoadingState extends TransferSquadState {}

class GetTransferSquadSuccessfulState extends TransferSquadState {
  final TransferSquad transferSquad;
  GetTransferSquadSuccessfulState(this.transferSquad);
}

class GetTransferSquadFailedState extends TransferSquadState {
  final String error;
  GetTransferSquadFailedState(this.error);
}

abstract class TransferModelState {}

class GetTransferModelInitialState extends TransferModelState {}

class GetTransferModelLoadingState extends TransferModelState {}

class GetTransferModelSuccessfulState extends TransferModelState {
  final TransferModel transferModel;
  GetTransferModelSuccessfulState(this.transferModel);
}

class GetTransferModelFailedState extends TransferModelState {
  final String error;
  GetTransferModelFailedState(this.error);
}