import 'package:fantasy/features/guidelines/data/models/about_us_model.dart';
import 'package:fantasy/features/guidelines/data/models/faq_model.dart';
import 'package:fantasy/features/guidelines/data/models/feedback_title_model.dart';
import 'package:fantasy/features/guidelines/data/models/final_poll.dart';
import 'package:fantasy/features/guidelines/data/models/injury_model.dart';
import 'package:fantasy/features/guidelines/data/models/player_selected_model.dart';
import 'package:fantasy/features/guidelines/data/models/poll_model.dart';
import 'package:fantasy/features/guidelines/data/models/privacy_model.dart';
import 'package:fantasy/features/guidelines/data/models/terms_model.dart';
import 'package:fantasy/features/guidelines/data/models/week_player_stat.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';

abstract class FAQsState {}

class GetAllFAQsInitialState extends FAQsState {}

class GetAllFAQsSuccessfulState extends FAQsState {
  final List<FAQModel> faqs;
  GetAllFAQsSuccessfulState(this.faqs);
}

class GetAllFAQsFailedState extends FAQsState {
  final String error;
  GetAllFAQsFailedState(this.error);
}

class GetAllFAQsLoadingState extends FAQsState {}

abstract class TermsState {}

class GetAllTermsInitialState extends TermsState {}

class GetAllTermsSuccessfulState extends TermsState {
  final List<TermsModel> terms;
  GetAllTermsSuccessfulState(this.terms);
}

class GetAllTermsFailedState extends TermsState {
  final String error;
  GetAllTermsFailedState(this.error);
}

class GetAllTermsLoadingState extends TermsState {}

abstract class PrivacyState {}

class GetAllPrivacyInitialState extends PrivacyState {}

class GetAllPrivacySuccessfulState extends PrivacyState {
  final List<PrivacyModel> policies;
  GetAllPrivacySuccessfulState(this.policies);
}

class GetAllPrivacyFailedState extends PrivacyState {
  final String error;
  GetAllPrivacyFailedState(this.error);
}

class GetAllPrivacyLoadingState extends PrivacyState {}

abstract class FeedbackTitleState {}

class GetAllFeedbackTitleInitialState extends FeedbackTitleState {}

class GetAllFeedbackTitleSuccessfulState extends FeedbackTitleState {
  final List<FeedbackTitleModel> titles;
  GetAllFeedbackTitleSuccessfulState(this.titles);
}

class GetAllFeedbackTitleFailedState extends FeedbackTitleState {
  final String error;
  GetAllFeedbackTitleFailedState(this.error);
}

class GetAllFeedbackTitleLoadingState extends FeedbackTitleState {}

abstract class PostFeedbackState {}

class PostFeedbackInitialState extends PostFeedbackState {}

class PostFeedbackSuccessfulState extends PostFeedbackState {}

class PostFeedbackLoadingState extends PostFeedbackState {}

class PostFeedbackFailedState extends PostFeedbackState {
  final String error;
  PostFeedbackFailedState(this.error);
}

abstract class AboutUsState {}

class GetAboutUsInitialState extends AboutUsState {}

class GetAboutUsSuccessfulState extends AboutUsState {
  final List<AboutUsModel> content;
  GetAboutUsSuccessfulState(this.content);
}

class GetAboutUsFailedState extends AboutUsState {
  final String error;
  GetAboutUsFailedState(this.error);
}

class GetAboutUsLoadingState extends AboutUsState {}

abstract class PlayerStatState {}

class GetPlayerStatInitialState extends PlayerStatState {}

class GetPlayerStatLoadingState extends PlayerStatState {}

class GetPlayerStatSuccessfulState extends PlayerStatState {
  final WeeklyPlayerStat players;
  GetPlayerStatSuccessfulState(this.players);
}

class GetPlayerStatFailedState extends PlayerStatState {
  final String error;
  GetPlayerStatFailedState(this.error);
}

abstract class PlayerSelectedStatState {}

class GetPlayerSelectedStatInitialState extends PlayerSelectedStatState {}

class GetPlayerSelectedStatLoadingState extends PlayerSelectedStatState {}

class GetPlayerSelectedStatSuccessfulState extends PlayerSelectedStatState {
  final PlayerSelectedStat stat;
  GetPlayerSelectedStatSuccessfulState(this.stat);
}

class GetPlayerSelectedStatFailedState extends PlayerSelectedStatState {
  final String error;
  GetPlayerSelectedStatFailedState(this.error);
}

abstract class DoneGameWeekState {}

class GetGameWeekInitialState extends DoneGameWeekState {}

class GetGameWeekLoadingState extends DoneGameWeekState {}

class GetGameWeekSuccessfulState extends DoneGameWeekState {
  final List<GameWeek> gameWeeks;
  GetGameWeekSuccessfulState(this.gameWeeks);
}

class GetGameWeekFailedState extends DoneGameWeekState {
  final String error;
  GetGameWeekFailedState(this.error);
}

abstract class InjuredPlayerState {}

class GetInjuredPlayerInitialState extends InjuredPlayerState {}

class GetInjuredPlayerLoadingState extends InjuredPlayerState {}

class GetInjuredPlayerSuccessfulState extends InjuredPlayerState {
  final List<InjuryModel> injuredPlayers;
  GetInjuredPlayerSuccessfulState(this.injuredPlayers);
}

class GetInjuredPlayerFailedState extends InjuredPlayerState {
  final String error;
  GetInjuredPlayerFailedState(this.error);
}

abstract class PollsState {}

class GetPollsInitialState extends PollsState {}

class GetPollsLoadingState extends PollsState {}

class GetPollsSuccessfulState extends PollsState {
  final FinalPoll polls;
  GetPollsSuccessfulState(this.polls);
}

class GetPollsFailedState extends PollsState {
  final String error;
  GetPollsFailedState(this.error);
}

abstract class PatchPollsState {}

class PatchPollsInitialState extends PatchPollsState {}

class PatchPollsLoadingState extends PatchPollsState {}

class PatchPollsSuccessfulState extends PatchPollsState {}

class PatchPollsFailedState extends PatchPollsState {
  final String error;
  PatchPollsFailedState(this.error);
}