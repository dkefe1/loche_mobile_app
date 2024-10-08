import 'package:fantasy/features/profile/data/models/agent_transaction.dart';
import 'package:fantasy/features/profile/data/models/agents.dart';
import 'package:fantasy/features/profile/data/models/awards.dart';
import 'package:fantasy/features/profile/data/models/bank.dart';
import 'package:fantasy/features/profile/data/models/client_request.dart';
import 'package:fantasy/features/profile/data/models/notes.dart';
import 'package:fantasy/features/profile/data/models/package.dart';
import 'package:fantasy/features/profile/data/models/profile_section.dart';
import 'package:fantasy/features/profile/data/models/scout.dart';
import 'package:fantasy/features/profile/data/models/transaction_history.dart';

abstract class ProfileState {}

class GetProfileInitialState extends ProfileState {}

class GetProfileSuccessfulState extends ProfileState {
  final ProfileSection profile;
  GetProfileSuccessfulState(this.profile);
}

class GetProfileLoadingState extends ProfileState {}

class GetProfileFailedState extends ProfileState {
  final String error;
  GetProfileFailedState(this.error);
}

abstract class UpdateProfileState {}

class UpdateProfileInitialState extends UpdateProfileState {}

class UpdateProfileSuccessfulState extends UpdateProfileState {}

class UpdateProfileLoadingState extends UpdateProfileState {}

class UpdateProfileFailedState extends UpdateProfileState {
  final String error;
  UpdateProfileFailedState(this.error);
}

abstract class UpdatePinState {}

class UpdatePinInitialState extends UpdatePinState {}

class UpdatePinSuccessfulState extends UpdatePinState {}

class UpdatePinLoadingState extends UpdatePinState {}

class UpdatePinFailedState extends UpdatePinState {
  final String error;
  UpdatePinFailedState(this.error);
}

abstract class UpdateProPicState {}

class UpdateProPicInitialState extends UpdateProPicState {}

class UpdateProPicSuccessfulState extends UpdateProPicState {}

class UpdateProPicLoadingState extends UpdateProPicState {}

class UpdateProPicFailedState extends UpdateProPicState {
  final String error;
  UpdateProPicFailedState(this.error);
}

abstract class NotesState {}

class GetAllNotesInitialState extends NotesState {}

class GetAllNotesSuccessfulState extends NotesState {
  final List<Notes> notes;
  GetAllNotesSuccessfulState(this.notes);
}

class GetAllNotesFailedState extends NotesState {
  final String error;
  GetAllNotesFailedState(this.error);
}

class GetAllNotesLoadingState extends NotesState {}

abstract class PostNoteState {}

class PostNoteInitialState extends PostNoteState {}

class PostNoteSuccessfulState extends PostNoteState {}

class PostNoteLoadingState extends PostNoteState {}

class PostNoteFailedState extends PostNoteState {
  final String error;
  PostNoteFailedState(this.error);
}

abstract class PatchNoteState {}

class PatchNoteInitialState extends PatchNoteState {}

class PatchNoteSuccessfulState extends PatchNoteState {}

class PatchNoteLoadingState extends PatchNoteState {}

class PatchNoteFailedState extends PatchNoteState {
  final String error;
  PatchNoteFailedState(this.error);
}

abstract class DeleteNoteState {}

class DeleteNoteInitialState extends DeleteNoteState {}

class DeleteNoteSuccessfulState extends DeleteNoteState {}

class DeleteNoteLoadingState extends DeleteNoteState {}

class DeleteNoteFailedState extends DeleteNoteState {
  final String error;
  DeleteNoteFailedState(this.error);
}

abstract class DeleteAllNoteState {}

class DeleteAllNoteInitialState extends DeleteAllNoteState {}

class DeleteAllNoteSuccessfulState extends DeleteAllNoteState {}

class DeleteAllNoteLoadingState extends DeleteAllNoteState {}

class DeleteAllNoteFailedState extends DeleteAllNoteState {
  final String error;
  DeleteAllNoteFailedState(this.error);
}

abstract class ScoutsState {}

class GetAllScoutsInitialState extends ScoutsState {}

class GetAllScoutsSuccessfulState extends ScoutsState {
  final List<Scout> scouts;
  GetAllScoutsSuccessfulState(this.scouts);
}

class GetAllScoutsFailedState extends ScoutsState {
  final String error;
  GetAllScoutsFailedState(this.error);
}

class GetAllScoutsLoadingState extends ScoutsState {}

abstract class PostScoutState {}

class PostScoutInitialState extends PostScoutState {}

class PostScoutSuccessfulState extends PostScoutState {}

class PostScoutLoadingState extends PostScoutState {}

class PostScoutFailedState extends PostScoutState {
  final String error;
  PostScoutFailedState(this.error);
}

abstract class DeleteScoutState {}

class DeleteScoutInitialState extends DeleteScoutState {}

class DeleteScoutSuccessfulState extends DeleteScoutState {}

class DeleteScoutLoadingState extends DeleteScoutState {}

class DeleteScoutFailedState extends DeleteScoutState {
  final String error;
  DeleteScoutFailedState(this.error);
}

abstract class AgentCodeState {}

class AgentCodeInitialState extends AgentCodeState {}

class AgentCodeSuccessfulState extends AgentCodeState {}

class AgentCodeLoadingState extends AgentCodeState {}

class AgentCodeFailedState extends AgentCodeState {
  final String error;
  AgentCodeFailedState(this.error);
}

abstract class ClientRequestState {}

class GetClientRequestInitialState extends ClientRequestState {}

class GetClientRequestSuccessfulState extends ClientRequestState {
  final ClientRequest? clientRequest;
  GetClientRequestSuccessfulState(this.clientRequest);
}

class GetClientRequestLoadingState extends ClientRequestState {}

class GetClientRequestFailedState extends ClientRequestState {
  final String error;
  GetClientRequestFailedState(this.error);
}

abstract class DepositCreditState {}

class PostDepositCreditInitialState extends DepositCreditState {}

class PostDepositCreditSuccessfulState extends DepositCreditState {
  final String checkout_url;
  PostDepositCreditSuccessfulState(this.checkout_url);
}

class PostDepositCreditLoadingState extends DepositCreditState {}

class PostDepositCreditFailedState extends DepositCreditState {
  final String error;
  PostDepositCreditFailedState(this.error);
}

abstract class TransactionsHistoryState {}

class GetTransactionsHistoryInitialState extends TransactionsHistoryState {}

class GetTransactionsHistorySuccessfulState extends TransactionsHistoryState {
  final List<TransactionHistory> transactions;
  GetTransactionsHistorySuccessfulState(this.transactions);
}

class GetTransactionsHistoryFailedState extends TransactionsHistoryState {
  final String error;
  GetTransactionsHistoryFailedState(this.error);
}

class GetTransactionsHistoryLoadingState extends TransactionsHistoryState {}

abstract class AgentTransactionsHistoryState {}

class GetAgentTransactionsHistoryInitialState extends AgentTransactionsHistoryState {}

class GetAgentTransactionsHistorySuccessfulState extends AgentTransactionsHistoryState {
  final List<AgentTransaction> transactions;
  GetAgentTransactionsHistorySuccessfulState(this.transactions);
}

class GetAgentTransactionsHistoryFailedState extends AgentTransactionsHistoryState {
  final String error;
  GetAgentTransactionsHistoryFailedState(this.error);
}

class GetAgentTransactionsHistoryLoadingState extends AgentTransactionsHistoryState {}

abstract class WithdrawState {}

class PostWithdrawInitialState extends WithdrawState {}

class PostWithdrawSuccessfulState extends WithdrawState {}

class PostWithdrawFailedState extends WithdrawState {
  final String error;
  PostWithdrawFailedState(this.error);
}

class PostWithdrawLoadingState extends WithdrawState {}

abstract class BankState {}

class GetBankInitialState extends BankState {}

class GetBankSuccessfulState extends BankState {
  final List<Bank> banks;
  GetBankSuccessfulState(this.banks);
}

class GetBankFailedState extends BankState {
  final String error;
  GetBankFailedState(this.error);
}

class GetBankLoadingState extends BankState {}

abstract class AwardsState {}

class GetAwardsInitialState extends AwardsState {}

class GetAwardsSuccessfulState extends AwardsState {
  final List<Awards> awards;
  GetAwardsSuccessfulState(this.awards);
}

class GetAwardsFailedState extends AwardsState {
  final String error;
  GetAwardsFailedState(this.error);
}

class GetAwardsLoadingState extends AwardsState {}

abstract class TransferCreditState {}

class PostTransferCreditInitialState extends TransferCreditState {}

class PostTransferCreditSuccessfulState extends TransferCreditState {}

class PostTransferCreditLoadingState extends TransferCreditState {}

class PostTransferCreditFailedState extends TransferCreditState {
  final String error;
  PostTransferCreditFailedState(this.error);
}

abstract class AgentState {}

class GetAgentInitialState extends AgentState {}

class GetAgentSuccessfulState extends AgentState {
  final List<Agents> agents;
  GetAgentSuccessfulState(this.agents);
}

class GetAgentFailedState extends AgentState {
  final String error;
  GetAgentFailedState(this.error);
}

class GetAgentLoadingState extends AgentState {}

abstract class PackagesState {}

class GetPackagesInitialState extends PackagesState {}

class GetPackagesSuccessfulState extends PackagesState {
  final List<PackageModel> packages;
  GetPackagesSuccessfulState(this.packages);
}

class GetPackagesFailedState extends PackagesState {
  final String error;
  GetPackagesFailedState(this.error);
}

class GetPackagesLoadingState extends PackagesState {}