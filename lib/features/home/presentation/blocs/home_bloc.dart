import 'package:fantasy/features/home/data/repositories/home_repositories.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvertisementBloc extends Bloc<AdvertisementEvent, AdvertisementState> {

  HomeRepositories homeRepositories;

  AdvertisementBloc(this.homeRepositories) : super(GetAdvertisementInitialState()){
    on<GetAdvertisementEvent>(_onGetAdvertisementEvent);
  }

  void _onGetAdvertisementEvent(GetAdvertisementEvent event, Emitter emit) async {
    emit(GetAdvertisementLoadingState());
    try{
      final content = await homeRepositories.getAds(event.adPackage);
      emit(GetAdvertisementSuccessfulState(content));
    } catch(e) {
      emit(GetAdvertisementFailedState(e.toString()));
    }
  }

}

class SquadBloc extends Bloc<SquadEvent, SquadState> {

  HomeRepositories homeRepositories;

  SquadBloc(this.homeRepositories) : super(GetSquadInitialState()){
    on<GetSquadEvent>(_onGetSquadEvent);
  }

  void _onGetSquadEvent(GetSquadEvent event, Emitter emit) async {
    emit(GetSquadLoadingState());
    try{
      final squads = await homeRepositories.getSquads();
      emit(GetSquadSuccessfulState(squads));
    } catch(e) {
      emit(GetSquadFailedState(e.toString()));
    }
  }

}

class TransferSquadBloc extends Bloc<TransferSquadEvent, TransferSquadState> {

  HomeRepositories homeRepositories;

  TransferSquadBloc(this.homeRepositories) : super(GetTransferSquadInitialState()){
    on<GetTransferSquadEvent>(_onGetTransferSquadEvent);
  }

  void _onGetTransferSquadEvent(GetTransferSquadEvent event, Emitter emit) async {
    emit(GetTransferSquadLoadingState());
    try{
      final transferSquad = await homeRepositories.getTransferSquads();
      emit(GetTransferSquadSuccessfulState(transferSquad));
    } catch(e) {
      emit(GetTransferSquadFailedState(e.toString()));
    }
  }

}

class CoachBloc extends Bloc<CoachEvent, CoachState> {

  HomeRepositories homeRepositories;

  CoachBloc(this.homeRepositories) : super(GetCoachInitialState()){
    on<GetCoachEvent>(_onGetCoachEvent);
  }

  void _onGetCoachEvent(GetCoachEvent event, Emitter emit) async {
    emit(GetCoachLoadingState());
    try{
      final coaches = await homeRepositories.getCoaches();
      emit(GetCoachSuccessfulState(coaches));
    } catch(e) {
      emit(GetCoachFailedState(e.toString()));
    }
  }

}

class CreateTeamBloc extends Bloc<CreateTeamEvent, CreateTeamState> {

  HomeRepositories homeRepositories;

  CreateTeamBloc(this.homeRepositories) : super(CreateTeamInitialState()){
    on<PostTeamEvent>(_onPostTeamEvent);
  }

  void _onPostTeamEvent(PostTeamEvent event, Emitter emit) async {
    emit(CreateTeamLoadingState());
    try{
      await homeRepositories.createTeam(event.createTeamModel);
      emit(CreateTeamSuccessfulState());
    } catch(e) {
      emit(CreateTeamFailedState(e.toString()));
    }
  }

}

class TeamNameBloc extends Bloc<TeamNameEvent, TeamNameState> {

  HomeRepositories homeRepositories;

  TeamNameBloc(this.homeRepositories) : super(TeamNameInitialState()){
    on<CheckTeamNameEvent>(_onCheckTeamNameEvent);
  }

  void _onCheckTeamNameEvent(CheckTeamNameEvent event, Emitter emit) async {
    emit(TeamNameLoadingState());
    try{
      final isAvailable = await homeRepositories.checkTeamNameAvailability(event.teamName);
      emit(TeamNameSuccessfulState(isAvailable));
    } catch(e) {
      emit(TeamNameFailedState(e.toString()));
    }
  }

}

class ClientTeamBloc extends Bloc<ClientTeamEvent, ClientTeamState> {

  HomeRepositories homeRepositories;

  ClientTeamBloc(this.homeRepositories) : super(ClientTeamInitialState()){
    on<GetClientTeamEvent>(_onGetClientTeamEvent);
  }

  void _onGetClientTeamEvent(GetClientTeamEvent event, Emitter emit) async {
    emit(ClientTeamLoadingState());
    try{
      final team = await homeRepositories.getClientTeam();
      emit(ClientTeamSuccessfulState(team));
    } catch(e) {
      emit(ClientTeamFailedState(e.toString()));
    }
  }

}

class SwitchPlayerBloc extends Bloc<SwitchPlayerEvent, SwitchPlayerState> {

  HomeRepositories homeRepositories;

  SwitchPlayerBloc(this.homeRepositories) : super(SwitchPlayerInitialState()){
    on<PatchSwitchPlayerEvent>(_onPatchSwitchPlayerEvent);
  }

  void _onPatchSwitchPlayerEvent(PatchSwitchPlayerEvent event, Emitter emit) async {
    emit(SwitchPlayerLoadingState());
    try{
      await homeRepositories.switchPlayers(event.playerToBeIn, event.playerToBeOut);
      emit(SwitchPlayerSuccessfulState());
    } catch(e) {
      emit(SwitchPlayerFailedState(e.toString()));
    }
  }

}

class TransferPlayerBloc extends Bloc<TransferPlayerEvent, TransferPlayerState> {

  HomeRepositories homeRepositories;

  TransferPlayerBloc(this.homeRepositories) : super(TransferPlayerInitialState()){
    on<PatchTransferPlayerEvent>(_onPatchTransferPlayerEvent);
  }

  void _onPatchTransferPlayerEvent(PatchTransferPlayerEvent event, Emitter emit) async {
    emit(TransferPlayerLoadingState());
    try{
      await homeRepositories.transferPlayers(event.playerToBeOut, event.transferPlayerModel);
      emit(TransferPlayerSuccessfulState());
    } catch(e) {
      emit(TransferPlayerFailedState(e.toString()));
    }
  }

}

class SwapPlayerBloc extends Bloc<SwapPlayerEvent, SwapPlayerState> {

  HomeRepositories homeRepositories;

  SwapPlayerBloc(this.homeRepositories) : super(SwapPlayerInitialState()){
    on<PatchSwapPlayerEvent>(_onPatchSwapPlayerEvent);
  }

  void _onPatchSwapPlayerEvent(PatchSwapPlayerEvent event, Emitter emit) async {
    emit(SwapPlayerLoadingState());
    try{
      await homeRepositories.swapPlayers(event.playerToBeIn, event.playerToBeOut);
      emit(SwapPlayerSuccessfulState());
    } catch(e) {
      emit(SwapPlayerFailedState(e.toString()));
    }
  }

}

class GameWeekBloc extends Bloc<GameWeekEvent, GameWeekState> {

  HomeRepositories homeRepositories;

  GameWeekBloc(this.homeRepositories) : super(GetGameWeekInitialState()){
    on<GetGameWeekEvent>(_onGetGameWeekEvent);
  }

  void _onGetGameWeekEvent(GetGameWeekEvent event, Emitter emit) async {
    emit(GetGameWeekLoadingState());
    try{
      final gameWeeks = await homeRepositories.getGameWeeks();
      emit(GetGameWeekSuccessfulState(gameWeeks));
    } catch(e) {
      emit(GetGameWeekFailedState(e.toString()));
    }
  }

}

class JoinedGameWeekTeamBloc extends Bloc<JoinedGameWeekTeamEvent, JoinedGameWeekTeamState> {

  HomeRepositories homeRepositories;

  JoinedGameWeekTeamBloc(this.homeRepositories) : super(GetJoinedGameWeekTeamInitialState()){
    on<GetJoinedGameWeekTeamEvent>(_onGetJoinedGameWeekTeamEvent);
  }

  void _onGetJoinedGameWeekTeamEvent(GetJoinedGameWeekTeamEvent event, Emitter emit) async {
    emit(GetJoinedGameWeekTeamLoadingState());
    try{
      final joinedGameWeekTeam = await homeRepositories.getJoinedGameWeekTeam();
      emit(GetJoinedGameWeekTeamSuccessfulState(joinedGameWeekTeam));
    } catch(e) {
      emit(GetJoinedGameWeekTeamFailedState(e.toString()));
    }
  }

}

class JoinGameWeekTeamBloc extends Bloc<JoinGameWeekTeamEvent, JoinGameWeekTeamState> {

  HomeRepositories homeRepositories;

  JoinGameWeekTeamBloc(this.homeRepositories) : super(PostJoinGameWeekTeamInitialState()){
    on<PostJoinGameWeekTeamEvent>(_onPostJoinGameWeekTeamEvent);
  }

  void _onPostJoinGameWeekTeamEvent(PostJoinGameWeekTeamEvent event, Emitter emit) async {
    emit(PostJoinGameWeekTeamLoadingState());
    try{
      await homeRepositories.joinGameWeekTeam(event.cid);
      emit(PostJoinGameWeekTeamSuccessfulState());
    } catch(e) {
      emit(PostJoinGameWeekTeamFailedState(e.toString()));
    }
  }

}

class TransferHistoryBloc extends Bloc<TransferHistoryEvent, TransferHistoryState> {

  HomeRepositories homeRepositories;

  TransferHistoryBloc(this.homeRepositories) : super(GetTransferHistoryInitialState()){
    on<GetTransferHistoryEvent>(_onGetTransferHistoryEvent);
  }

  void _onGetTransferHistoryEvent(GetTransferHistoryEvent event, Emitter emit) async {
    emit(GetTransferHistoryLoadingState());
    try{
      final content = await homeRepositories.getTransferHistory(event.page);
      emit(GetTransferHistorySuccessfulState(content));
    } catch(e) {
      emit(GetTransferHistoryFailedState(e.toString()));
    }
  }

}

class JoinedGameWeekBloc extends Bloc<JoinedGameWeekEvent, JoinedGameWeekState> {

  HomeRepositories homeRepositories;

  JoinedGameWeekBloc(this.homeRepositories) : super(GetJoinedGameWeekInitialState()){
    on<GetJoinedGameWeekEvent>(_onGetJoinedGameWeekEvent);
  }

  void _onGetJoinedGameWeekEvent(GetJoinedGameWeekEvent event, Emitter emit) async {
    emit(GetJoinedGameWeekLoadingState());
    try{
      final joinedGameWeek = await homeRepositories.getJoinedGameWeeks();
      emit(GetJoinedGameWeekSuccessfulState(joinedGameWeek));
    } catch(e) {
      emit(GetJoinedGameWeekFailedState(e.toString()));
    }
  }

}

class AppVersionBloc extends Bloc<AppVersionEvent, AppVersionState> {

  HomeRepositories homeRepositories;

  AppVersionBloc(this.homeRepositories) : super(GetAppVersionInitialState()){
    on<GetAppVersionEvent>(_onGetAppVersionEvent);
  }

  void _onGetAppVersionEvent(GetAppVersionEvent event, Emitter emit) async {
    emit(GetAppVersionLoadingState());
    try{
      final appVersion = await homeRepositories.getAppVersion(event.platformType);
      emit(GetAppVersionSuccessfulState(appVersion));
    } catch(e) {
      emit(GetAppVersionFailedState(e.toString()));
    }
  }

}

class ActiveGameWeekBloc extends Bloc<ActiveGameWeekEvent, ActiveGameWeekState> {

  HomeRepositories homeRepositories;

  ActiveGameWeekBloc(this.homeRepositories) : super(GetActiveGameWeekInitialState()){
    on<GetActiveGameWeekEvent>(_onGetActiveGameWeekEvent);
  }

  void _onGetActiveGameWeekEvent(GetActiveGameWeekEvent event, Emitter emit) async {
    emit(GetActiveGameWeekLoadingState());
    try{
      final activeGameWeek = await homeRepositories.getActiveGameWeek();
      emit(GetActiveGameWeekSuccessfulState(activeGameWeek));
    } catch(e) {
      emit(GetActiveGameWeekFailedState(e.toString()));
    }
  }

}

class MyCoachBloc extends Bloc<MyCoachEvent, MyCoachState> {

  HomeRepositories homeRepositories;

  MyCoachBloc(this.homeRepositories) : super(GetMyCoachInitialState()){
    on<GetMyCoachEvent>(_onGetMyCoachEvent);
  }

  void _onGetMyCoachEvent(GetMyCoachEvent event, Emitter emit) async {
    emit(GetMyCoachLoadingState());
    try{
      final coach = await homeRepositories.getCoach(event.coachId, event.useLocal);
      emit(GetMyCoachSuccessfulState(coach));
    } catch(e) {
      emit(GetMyCoachFailedState(e.toString()));
    }
  }

}

class JoinedClientGameWeekBloc extends Bloc<JoinedClientGameWeekEvent, JoinedClientGameWeekState> {

  HomeRepositories homeRepositories;

  JoinedClientGameWeekBloc(this.homeRepositories) : super(GetJoinedClientGameWeekInitialState()){
    on<GetJoinedClientGameWeekEvent>(_onGetJoinedClientGameWeekEvent);
  }

  void _onGetJoinedClientGameWeekEvent(GetJoinedClientGameWeekEvent event, Emitter emit) async {
    emit(GetJoinedClientGameWeekLoadingState());
    try{
      final team = await homeRepositories.getJoinedClientGameWeek(event.gameWeekId);
      emit(GetJoinedClientGameWeekSuccessfulState(team));
    } catch(e) {
      emit(GetJoinedClientGameWeekFailedState(e.toString()));
    }
  }

}

class PatchTeamBloc extends Bloc<PatchTeamEvent, PatchTeamState> {

  HomeRepositories homeRepositories;

  PatchTeamBloc(this.homeRepositories) : super(PatchTeamInitialState()){
    on<UpdateTeamEvent>(_onUpdateTeamEvent);
  }

  void _onUpdateTeamEvent(UpdateTeamEvent event, Emitter emit) async {
    emit(PatchTeamLoadingState());
    try{
      await homeRepositories.patchTeam(event.favorite_coach, event.favorite_tactic, event.teamId);
      emit(PatchTeamSuccessfulState());
    } catch(e) {
      emit(PatchTeamFailedState(e.toString()));
    }
  }

}

class ResetTeamBloc extends Bloc<ResetTeamEvent, ResetTeamState> {

  HomeRepositories homeRepositories;

  ResetTeamBloc(this.homeRepositories) : super(ResetTeamInitialState()){
    on<PatchResetTeamEvent>(_onPatchResetTeamEvent);
  }

  void _onPatchResetTeamEvent(PatchResetTeamEvent event, Emitter emit) async {
    emit(ResetTeamLoadingState());
    try{
      await homeRepositories.resetTeam();
      emit(ResetTeamSuccessfulState());
    } catch(e) {
      emit(ResetTeamFailedState(e.toString()));
    }
  }

}

class RecreateTeamBloc extends Bloc<RecreateTeamEvent, RecreateTeamState> {

  HomeRepositories homeRepositories;

  RecreateTeamBloc(this.homeRepositories) : super(RecreateTeamInitialState()){
    on<PatchRecreateTeamEvent>(_onPatchRecreateTeamEvent);
  }

  void _onPatchRecreateTeamEvent(PatchRecreateTeamEvent event, Emitter emit) async {
    emit(RecreateTeamLoadingState());
    try{
      await homeRepositories.recreateTeam(event.players);
      emit(RecreateTeamSuccessfulState());
    } catch(e) {
      emit(RecreateTeamFailedState(e.toString()));
    }
  }

}

class TransferModelBloc extends Bloc<TransferModelEvent, TransferModelState> {

  HomeRepositories homeRepositories;

  TransferModelBloc(this.homeRepositories) : super(GetTransferModelInitialState()){
    on<GetTransferModelEvent>(_onGetTransferModelEvent);
  }

  void _onGetTransferModelEvent(GetTransferModelEvent event, Emitter emit) async {
    emit(GetTransferModelLoadingState());
    try{
      final transferModel = await homeRepositories.getTransferModel();
      emit(GetTransferModelSuccessfulState(transferModel));
    } catch(e) {
      emit(GetTransferModelFailedState(e.toString()));
    }
  }

}