import 'package:fantasy/features/fixture/data/repositories/fixture_repositories.dart';
import 'package:fantasy/features/fixture/presentation/blocs/fixture_event.dart';
import 'package:fantasy/features/fixture/presentation/blocs/fixture_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FixtureBloc extends Bloc<FixtureEvent, FixtureState> {
  FixtureRepositories fixtureRepositories;
  FixtureBloc(this.fixtureRepositories) : super(GetFixtureInitialState()){
    on<GetFixturesEvent>(_onGetFixtureEvent);
  }

  void _onGetFixtureEvent(GetFixturesEvent event, Emitter emit) async {
    emit(GetFixtureLoadingState());
    try{
      final matches = await fixtureRepositories.getMatches(event.round);
      emit(GetFixtureSuccessfulState(matches));
    } catch(e){
      emit(GetFixtureFailedState(e.toString()));
    }
  }
}

class MatchInfoBloc extends Bloc<MatchInfoEvent, MatchInfoState> {
  FixtureRepositories fixtureRepositories;
  MatchInfoBloc(this.fixtureRepositories) : super(GetMatchInfoInitialState()){
    on<GetMatchInfoEvent>(_onGetMatchInfoEvent);
  }

  void _onGetMatchInfoEvent(GetMatchInfoEvent event, Emitter emit) async {
    emit(GetMatchInfoLoadingState());
    try{
      final matchInfo = await fixtureRepositories.getMatchInfo(event.matchId);
      emit(GetMatchInfoSuccessfulState(matchInfo));
    } catch(e){
      emit(GetMatchInfoFailedState(e.toString()));
    }
  }
}