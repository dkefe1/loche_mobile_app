abstract class FAQsEvent {}

class GetAllFAQsEvent extends FAQsEvent {}

abstract class TermsEvent {}

class GetAllTermsEvent extends TermsEvent {}

abstract class PrivacyEvent {}

class GetAllPrivacyEvent extends PrivacyEvent {}

abstract class FeedbackTitleEvent {}

class GetAllFeedbackTitleEvent extends FeedbackTitleEvent {}

abstract class PostFeedbackEvent {}

class CreateFeedbackEvent extends PostFeedbackEvent {
  final String title, content;
  CreateFeedbackEvent(this.title, this.content);
}

abstract class AboutUsEvent {}

class GetAboutUsEvent extends AboutUsEvent {}

abstract class PlayerStatEvent {}

class GetPlayerStatEvent extends PlayerStatEvent {
  final String gameWeekId;
  final bool isAllTime;
  GetPlayerStatEvent(this.gameWeekId, this.isAllTime);
}

abstract class PlayerSelectedStatEvent {}

class GetPlayerSelectedStatEvent extends PlayerSelectedStatEvent {
  final String? gameWeekId;
  GetPlayerSelectedStatEvent(this.gameWeekId);
}

abstract class DoneGameWeekEvent {}

class GetDoneGameWeekEvent extends DoneGameWeekEvent {}

abstract class InjuredPlayerEvent {}

class GetInjuredPlayerEvent extends InjuredPlayerEvent {
  final bool isLatest;
  GetInjuredPlayerEvent(this.isLatest);
}

abstract class PollsEvent {}

class GetPollsEvent extends PollsEvent {
  final String page;
  GetPollsEvent(this.page);
}

abstract class PatchPollsEvent {}

class ChoosePollsEvent extends PatchPollsEvent {
  final String pol_id, choice_id;
  ChoosePollsEvent(this.pol_id, this.choice_id);
}