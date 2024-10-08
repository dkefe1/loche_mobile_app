import 'package:fantasy/features/profile/data/models/agent_code.dart';
import 'package:fantasy/features/profile/data/models/scout.dart';
import 'package:fantasy/features/profile/data/models/update_pin.dart';
import 'package:fantasy/features/profile/data/models/update_profile.dart';
import 'package:fantasy/features/profile/data/models/withdraw.dart';

abstract class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

abstract class UpdateProfileEvent {}

class PatchUpdateEvent extends UpdateProfileEvent {
  final UpdateProfile updateProfile;
  PatchUpdateEvent(this.updateProfile);
}

abstract class UpdatePinEvent {}

class PatchPinEvent extends UpdatePinEvent {
  final UpdatePin updatePin;
  PatchPinEvent(this.updatePin);
}

abstract class UpdateProPicEvent {}

class PatchProPicEvent extends UpdateProPicEvent {
  final String id, url;
  PatchProPicEvent(this.id, this.url);
}

abstract class NotesEvent {}

class GetAllNotesEvent extends NotesEvent {}

abstract class PostNoteEvent {}

class CreateNoteEvent extends PostNoteEvent {
  final String note;
  CreateNoteEvent(this.note);
}

abstract class PatchNoteEvent {}

class UpdateNoteEvent extends PatchNoteEvent {
  final String id, note;
  UpdateNoteEvent(this.id, this.note);
}

abstract class DeleteNoteEvent {}

class RemoveNoteEvent extends DeleteNoteEvent {
  final String id;
  RemoveNoteEvent(this.id);
}

abstract class DeleteAllNoteEvent {}

class RemoveAllNoteEvent extends DeleteAllNoteEvent {}

abstract class ScoutsEvent {}

class GetAllScoutsEvent extends ScoutsEvent {}

abstract class PostScoutEvent {}

class CreateScoutEvent extends PostScoutEvent {
  final Scout scout;
  CreateScoutEvent(this.scout);
}

abstract class DeleteScoutEvent {}

class RemoveScoutEvent extends DeleteScoutEvent {
  final String id;
  RemoveScoutEvent(this.id);
}

abstract class AgentCodeEvent {}

class RequestAgentCodeEvent extends AgentCodeEvent {
  final AgentCode agentCode;
  RequestAgentCodeEvent(this.agentCode);
}

abstract class ClientRequestEvent {}

class GetClientRequestEvent extends ClientRequestEvent {}

abstract class DepositCreditEvent {}

class PostDepositCreditEvent extends DepositCreditEvent {
  final num amount;
  final num? gameweeks;
  final String phoneNumber;
  final bool autoJoin, isPackage, isAppCredit;
  PostDepositCreditEvent(this.amount, this.phoneNumber, this.autoJoin, this.isPackage, this.gameweeks, this.isAppCredit);
}

abstract class TransactionsHistoryEvent {}

class GetTransactionsHistoryEvent extends TransactionsHistoryEvent {
  final String page;
  GetTransactionsHistoryEvent(this.page);
}

abstract class AgentTransactionsHistoryEvent {}

class GetAgentTransactionsHistoryEvent extends AgentTransactionsHistoryEvent {
  final String page, clientId;
  GetAgentTransactionsHistoryEvent(this.page, this.clientId);
}

abstract class WithdrawEvent {}

class PostWithdrawEvent extends WithdrawEvent {
  final Withdraw withdraw;
  PostWithdrawEvent(this.withdraw);
}

abstract class BankEvent {}

class GetBankEvent extends BankEvent {}

abstract class AwardsEvent {}

class GetAwardsEvent extends AwardsEvent {
  final String clientId;
  GetAwardsEvent(this.clientId);
}

abstract class TransferCreditEvent {}

class PostTransferCreditEvent extends TransferCreditEvent {
  final num amount;
  final String phoneNumber;
  PostTransferCreditEvent(this.amount, this.phoneNumber);
}

abstract class AgentEvent {}

class GetAgentEvent extends AgentEvent {
  final String page, clientId;
  GetAgentEvent(this.clientId, this.page);
}

abstract class PackagesEvent {}

class GetPackagesEvent extends PackagesEvent {}