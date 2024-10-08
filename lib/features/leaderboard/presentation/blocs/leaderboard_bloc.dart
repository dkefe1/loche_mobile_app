import 'package:fantasy/features/leaderboard/data/repositories/leaderboard_repositories.dart';
import 'package:fantasy/features/leaderboard/presentation/blocs/leaderboard_event.dart';
import 'package:fantasy/features/leaderboard/presentation/blocs/leaderboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeeklyLeaderboardBloc extends Bloc<WeeklyLeaderboardEvent, WeeklyLeaderboardState> {

  LeaderboardRepositories leaderboardRepositories;

  WeeklyLeaderboardBloc(this.leaderboardRepositories) : super(GetWeeklyLeaderboardInitialState()){
    on<GetWeeklyLeaderboardEvent>(_onGetWeeklyLeaderboardEvent);
  }

  void _onGetWeeklyLeaderboardEvent(GetWeeklyLeaderboardEvent event, Emitter emit) async {
    emit(GetWeeklyLeaderboardLoadingState());
    try{
      final weeklyLeaderboard = await leaderboardRepositories.getWeeklyLeaderboard(event.gameWeekId, event.page);
      emit(GetWeeklyLeaderboardSuccessfulState(weeklyLeaderboard));
    } catch(e) {
      emit(GetWeeklyLeaderboardFailedState(e.toString()));
    }
  }

}

class YearlyLeaderboardBloc extends Bloc<YearlyLeaderboardEvent, YearlyLeaderboardState> {

  LeaderboardRepositories leaderboardRepositories;

  YearlyLeaderboardBloc(this.leaderboardRepositories) : super(GetYearlyLeaderboardInitialState()){
    on<GetYearlyLeaderboardEvent>(_onGetYearlyLeaderboardEvent);
  }

  void _onGetYearlyLeaderboardEvent(GetYearlyLeaderboardEvent event, Emitter emit) async {
    emit(GetYearlyLeaderboardLoadingState());
    try{
      final yearlyLeaderboard = await leaderboardRepositories.getYearlyLeaderboard(event.page);
      emit(GetYearlyLeaderboardSuccessfulState(yearlyLeaderboard));
    } catch(e) {
      emit(GetYearlyLeaderboardFailedState(e.toString()));
    }
  }

}

class MonthlyLeaderboardBloc extends Bloc<MonthlyLeaderboardEvent, MonthlyLeaderboardState> {

  LeaderboardRepositories leaderboardRepositories;

  MonthlyLeaderboardBloc(this.leaderboardRepositories) : super(GetMonthlyLeaderboardInitialState()){
    on<GetMonthlyLeaderboardEvent>(_onGetMonthlyLeaderboardEvent);
  }

  void _onGetMonthlyLeaderboardEvent(GetMonthlyLeaderboardEvent event, Emitter emit) async {
    emit(GetMonthlyLeaderboardLoadingState());
    try{
      final monthlyLeaderboard = await leaderboardRepositories.getMonthlyLeaderboard(event.currentTime, event.page);
      emit(GetMonthlyLeaderboardSuccessfulState(monthlyLeaderboard));
    } catch(e) {
      emit(GetMonthlyLeaderboardFailedState(e.toString()));
    }
  }

}

class LeaderClientTeamBloc extends Bloc<LeaderClientTeamEvent, LeaderClientTeamState> {

  LeaderboardRepositories leaderboardRepositories;

  LeaderClientTeamBloc(this.leaderboardRepositories) : super(GetLeaderClientTeamInitialState()){
    on<GetLeaderClientTeamEvent>(_onGetLeaderClientTeamEvent);
  }

  void _onGetLeaderClientTeamEvent(GetLeaderClientTeamEvent event, Emitter emit) async {
    emit(GetLeaderClientTeamLoadingState());
    try{
      final players = await leaderboardRepositories.getLeaderClientTeam(event.gameWeekId, event.clientId);
      emit(GetLeaderClientTeamSuccessfulState(players));
    } catch(e) {
      emit(GetLeaderClientTeamFailedState(e.toString()));
    }
  }

}

class OtherClientTeamBloc extends Bloc<OtherClientTeamEvent, OtherClientTeamState> {

  LeaderboardRepositories leaderboardRepositories;

  OtherClientTeamBloc(this.leaderboardRepositories) : super(GetOtherClientTeamInitialState()){
    on<GetOtherClientTeamEvent>(_onGetOtherClientTeamEvent);
  }

  void _onGetOtherClientTeamEvent(GetOtherClientTeamEvent event, Emitter emit) async {
    emit(GetOtherClientTeamLoadingState());
    try{
      final players = await leaderboardRepositories.getOtherClientTeam(event.clientId);
      emit(GetOtherClientTeamSuccessfulState(players));
    } catch(e) {
      emit(GetOtherClientTeamFailedState(e.toString()));
    }
  }

}