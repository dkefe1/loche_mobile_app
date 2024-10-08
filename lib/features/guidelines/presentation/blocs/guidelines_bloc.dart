import 'package:fantasy/features/guidelines/data/repositories/guidelines_repository.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FAQsBloc extends Bloc<FAQsEvent, FAQsState> {

  GuidelinesRepository guidelinesRepository;

  FAQsBloc(this.guidelinesRepository) : super(GetAllFAQsInitialState()){
    on<GetAllFAQsEvent>(_onGetAllFAQsEvent);
  }

  void _onGetAllFAQsEvent(GetAllFAQsEvent event, Emitter emit) async {
    emit(GetAllFAQsLoadingState());
    try{
      final faqs = await guidelinesRepository.getAllFAQs();
      emit(GetAllFAQsSuccessfulState(faqs));
    } catch(e) {
      emit(GetAllFAQsFailedState(e.toString()));
    }
  }

}

class TermsBloc extends Bloc<TermsEvent, TermsState> {

  GuidelinesRepository guidelinesRepository;

  TermsBloc(this.guidelinesRepository) : super(GetAllTermsInitialState()){
    on<GetAllTermsEvent>(_onGetAllTermsEvent);
  }

  void _onGetAllTermsEvent(GetAllTermsEvent event, Emitter emit) async {
    emit(GetAllTermsLoadingState());
    try{
      final terms = await guidelinesRepository.getAllTerms();
      emit(GetAllTermsSuccessfulState(terms));
    } catch(e) {
      emit(GetAllTermsFailedState(e.toString()));
    }
  }

}

class PrivacyBloc extends Bloc<PrivacyEvent, PrivacyState> {

  GuidelinesRepository guidelinesRepository;

  PrivacyBloc(this.guidelinesRepository) : super(GetAllPrivacyInitialState()){
    on<GetAllPrivacyEvent>(_onGetAllPrivacyEvent);
  }

  void _onGetAllPrivacyEvent(GetAllPrivacyEvent event, Emitter emit) async {
    emit(GetAllPrivacyLoadingState());
    try{
      final policies = await guidelinesRepository.getAllPolicies();
      emit(GetAllPrivacySuccessfulState(policies));
    } catch(e) {
      emit(GetAllPrivacyFailedState(e.toString()));
    }
  }

}

class FeedbackTitleBloc extends Bloc<FeedbackTitleEvent, FeedbackTitleState> {

  GuidelinesRepository guidelinesRepository;

  FeedbackTitleBloc(this.guidelinesRepository) : super(GetAllFeedbackTitleInitialState()){
    on<GetAllFeedbackTitleEvent>(_onGetAllFeedbackTitleEvent);
  }

  void _onGetAllFeedbackTitleEvent(GetAllFeedbackTitleEvent event, Emitter emit) async {
    emit(GetAllFeedbackTitleLoadingState());
    try{
      final titles = await guidelinesRepository.getAllFeedbaackTitle();
      emit(GetAllFeedbackTitleSuccessfulState(titles));
    } catch(e) {
      emit(GetAllFeedbackTitleFailedState(e.toString()));
    }
  }

}

class PostFeedbackBloc extends Bloc<PostFeedbackEvent, PostFeedbackState> {

  GuidelinesRepository guidelinesRepository;

  PostFeedbackBloc(this.guidelinesRepository) : super(PostFeedbackInitialState()){
    on<CreateFeedbackEvent>(_onCreateFeedbackEvent);
  }

  void _onCreateFeedbackEvent(CreateFeedbackEvent event, Emitter emit) async {
    emit(PostFeedbackLoadingState());
    try{
      await guidelinesRepository.postFeedback(event.title, event.content);
      emit(PostFeedbackSuccessfulState());
    } catch(e) {
      emit(PostFeedbackFailedState(e.toString()));
    }
  }

}

class AboutUsBloc extends Bloc<AboutUsEvent, AboutUsState> {

  GuidelinesRepository guidelinesRepository;

  AboutUsBloc(this.guidelinesRepository) : super(GetAboutUsInitialState()){
    on<GetAboutUsEvent>(_onGetAboutUsEvent);
  }

  void _onGetAboutUsEvent(GetAboutUsEvent event, Emitter emit) async {
    emit(GetAboutUsLoadingState());
    try{
      final content = await guidelinesRepository.getAboutUs();
      emit(GetAboutUsSuccessfulState(content));
    } catch(e) {
      emit(GetAboutUsFailedState(e.toString()));
    }
  }

}

class PlayerStatBloc extends Bloc<PlayerStatEvent, PlayerStatState> {

  GuidelinesRepository guidelinesRepository;

  PlayerStatBloc(this.guidelinesRepository) : super(GetPlayerStatInitialState()){
    on<GetPlayerStatEvent>(_onGetPlayerStatEvent);
  }

  void _onGetPlayerStatEvent(GetPlayerStatEvent event, Emitter emit) async {
    emit(GetPlayerStatLoadingState());
    try{
      final playerStats = await guidelinesRepository.getWeeklyPlayerStat(event.gameWeekId, event.isAllTime);
      emit(GetPlayerStatSuccessfulState(playerStats));
    } catch(e) {
      emit(GetPlayerStatFailedState(e.toString()));
    }
  }

}

class PlayerSelectedStatBloc extends Bloc<PlayerSelectedStatEvent, PlayerSelectedStatState> {

  GuidelinesRepository guidelinesRepository;

  PlayerSelectedStatBloc(this.guidelinesRepository) : super(GetPlayerSelectedStatInitialState()){
    on<GetPlayerSelectedStatEvent>(_onGetPlayerSelectedStatEvent);
  }

  void _onGetPlayerSelectedStatEvent(GetPlayerSelectedStatEvent event, Emitter emit) async {
    emit(GetPlayerSelectedStatLoadingState());
    try{
      final playerStats = await guidelinesRepository.getSelectedPlayerStat(event.gameWeekId);
      emit(GetPlayerSelectedStatSuccessfulState(playerStats));
    } catch(e) {
      emit(GetPlayerSelectedStatFailedState(e.toString()));
    }
  }

}

class DoneGameWeekBloc extends Bloc<DoneGameWeekEvent, DoneGameWeekState> {

  GuidelinesRepository guidelinesRepository;

  DoneGameWeekBloc(this.guidelinesRepository) : super(GetGameWeekInitialState()){
    on<GetDoneGameWeekEvent>(_onGetGameWeekEvent);
  }

  void _onGetGameWeekEvent(GetDoneGameWeekEvent event, Emitter emit) async {
    emit(GetGameWeekLoadingState());
    try{
      final gameWeeks = await guidelinesRepository.getGameWeeks();
      emit(GetGameWeekSuccessfulState(gameWeeks));
    } catch(e) {
      emit(GetGameWeekFailedState(e.toString()));
    }
  }

}

class InjuredPlayerBloc extends Bloc<InjuredPlayerEvent, InjuredPlayerState> {

  GuidelinesRepository guidelinesRepository;

  InjuredPlayerBloc(this.guidelinesRepository) : super(GetInjuredPlayerInitialState()){
    on<GetInjuredPlayerEvent>(_onGetInjuredPlayerEvent);
  }

  void _onGetInjuredPlayerEvent(GetInjuredPlayerEvent event, Emitter emit) async {
    emit(GetInjuredPlayerLoadingState());
    try{
      final injuredPlayers = await guidelinesRepository.getInjuredPlayers(event.isLatest);
      emit(GetInjuredPlayerSuccessfulState(injuredPlayers));
    } catch(e) {
      emit(GetInjuredPlayerFailedState(e.toString()));
    }
  }

}

class PollsBloc extends Bloc<PollsEvent, PollsState> {

  GuidelinesRepository guidelinesRepository;

  PollsBloc(this.guidelinesRepository) : super(GetPollsInitialState()){
    on<GetPollsEvent>(_onGetPollsEvent);
  }

  void _onGetPollsEvent(GetPollsEvent event, Emitter emit) async {
    emit(GetPollsLoadingState());
    try{
      final polls = await guidelinesRepository.getPolls(event.page);
      emit(GetPollsSuccessfulState(polls));
    } catch(e) {
      emit(GetPollsFailedState(e.toString()));
    }
  }

}

class PatchPollsBloc extends Bloc<PatchPollsEvent, PatchPollsState> {

  GuidelinesRepository guidelinesRepository;

  PatchPollsBloc(this.guidelinesRepository) : super(PatchPollsInitialState()){
    on<ChoosePollsEvent>(_onChoosePollsEvent);
  }

  void _onChoosePollsEvent(ChoosePollsEvent event, Emitter emit) async {
    emit(PatchPollsLoadingState());
    try{
      await guidelinesRepository.patchPoll(event.pol_id, event.choice_id);
      emit(PatchPollsSuccessfulState());
    } catch(e) {
      emit(PatchPollsFailedState(e.toString()));
    }
  }

}