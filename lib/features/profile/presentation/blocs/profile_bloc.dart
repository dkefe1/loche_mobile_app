import 'package:fantasy/features/profile/data/repositories/profile_repository.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepository profileRepository;
  ProfileBloc(this.profileRepository) : super(GetProfileInitialState()){
    on<GetProfileEvent>(_onGetProfileEvent);
  }

  void _onGetProfileEvent(GetProfileEvent event, Emitter emit) async {
    emit(GetProfileLoadingState());
    try {
      final profile = await profileRepository.getProfile();
      emit(GetProfileSuccessfulState(profile));
    } catch(e) {
      emit(GetProfileFailedState(e.toString()));
    }
  }
}

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  ProfileRepository profileRepository;
  UpdateProfileBloc(this.profileRepository) : super(UpdateProfileInitialState()){
    on<PatchUpdateEvent>(_onPatchUpdateEvent);
  }

  void _onPatchUpdateEvent(PatchUpdateEvent event, Emitter emit) async {
    emit(UpdateProfileLoadingState());
    try {
      await profileRepository.updateProfile(event.updateProfile);
      emit(UpdateProfileSuccessfulState());
    } catch(e) {
      emit(UpdateProfileFailedState(e.toString()));
    }
  }
}

class UpdatePinBloc extends Bloc<UpdatePinEvent, UpdatePinState> {
  ProfileRepository profileRepository;
  UpdatePinBloc(this.profileRepository) : super(UpdatePinInitialState()){
    on<PatchPinEvent>(_onPatchPinEvent);
  }

  void _onPatchPinEvent(PatchPinEvent event, Emitter emit) async {
    emit(UpdatePinLoadingState());
    try {
      await profileRepository.patchPin(event.updatePin);
      emit(UpdatePinSuccessfulState());
    } catch(e) {
      emit(UpdatePinFailedState(e.toString()));
    }
  }
}

class UpdateProPicBloc extends Bloc<UpdateProPicEvent, UpdateProPicState> {
  ProfileRepository profileRepository;
  UpdateProPicBloc(this.profileRepository) : super(UpdateProPicInitialState()){
    on<PatchProPicEvent>(_onPatchProPicEvent);
  }

  void _onPatchProPicEvent(PatchProPicEvent event, Emitter emit) async {
    emit(UpdateProPicLoadingState());
    try {
      await profileRepository.patchProPic(event.id, event.url);
      emit(UpdateProPicSuccessfulState());
    } catch(e) {
      emit(UpdateProPicFailedState(e.toString()));
    }
  }
}

class NotesBloc extends Bloc<NotesEvent, NotesState> {

  ProfileRepository profileRepository;

  NotesBloc(this.profileRepository) : super(GetAllNotesInitialState()){
    on<GetAllNotesEvent>(_onGetAllNotesEvent);
  }

  void _onGetAllNotesEvent(GetAllNotesEvent event, Emitter emit) async {
    emit(GetAllNotesLoadingState());
    try{
      final notes = await profileRepository.getNotes();
      emit(GetAllNotesSuccessfulState(notes));
    } catch(e) {
      emit(GetAllNotesFailedState(e.toString()));
    }
  }

}

class PostNoteBloc extends Bloc<PostNoteEvent, PostNoteState> {

  ProfileRepository profileRepository;

  PostNoteBloc(this.profileRepository) : super(PostNoteInitialState()){
    on<CreateNoteEvent>(_onCreateNoteEvent);
  }

  void _onCreateNoteEvent(CreateNoteEvent event, Emitter emit) async {
    emit(PostNoteLoadingState());
    try{
      await profileRepository.postNote(event.note);
      emit(PostNoteSuccessfulState());
    } catch(e) {
      emit(PostNoteFailedState(e.toString()));
    }
  }

}

class PatchNoteBloc extends Bloc<PatchNoteEvent, PatchNoteState> {

  ProfileRepository profileRepository;

  PatchNoteBloc(this.profileRepository) : super(PatchNoteInitialState()){
    on<UpdateNoteEvent>(_onUpdateNoteEvent);
  }

  void _onUpdateNoteEvent(UpdateNoteEvent event, Emitter emit) async {
    emit(PatchNoteLoadingState());
    try{
      await profileRepository.patchNote(event.id, event.note);
      emit(PatchNoteSuccessfulState());
    } catch(e) {
      emit(PatchNoteFailedState(e.toString()));
    }
  }

}

class DeleteNoteBloc extends Bloc<DeleteNoteEvent, DeleteNoteState> {

  ProfileRepository profileRepository;

  DeleteNoteBloc(this.profileRepository) : super(DeleteNoteInitialState()){
    on<RemoveNoteEvent>(_onRemoveNoteEvent);
  }

  void _onRemoveNoteEvent(RemoveNoteEvent event, Emitter emit) async {
    emit(DeleteNoteLoadingState());
    try{
      await profileRepository.deleteNote(event.id);
      emit(DeleteNoteSuccessfulState());
    } catch(e) {
      emit(DeleteNoteFailedState(e.toString()));
    }
  }

}

class DeleteAllNoteBloc extends Bloc<DeleteAllNoteEvent, DeleteAllNoteState> {

  ProfileRepository profileRepository;

  DeleteAllNoteBloc(this.profileRepository) : super(DeleteAllNoteInitialState()){
    on<RemoveAllNoteEvent>(_onRemoveAllNoteEvent);
  }

  void _onRemoveAllNoteEvent(RemoveAllNoteEvent event, Emitter emit) async {
    emit(DeleteAllNoteLoadingState());
    try{
      await profileRepository.deleteAllNote();
      emit(DeleteAllNoteSuccessfulState());
    } catch(e) {
      emit(DeleteAllNoteFailedState(e.toString()));
    }
  }

}

class ScoutsBloc extends Bloc<ScoutsEvent, ScoutsState> {

  ProfileRepository profileRepository;

  ScoutsBloc(this.profileRepository) : super(GetAllScoutsInitialState()){
    on<GetAllScoutsEvent>(_onGetAllScoutsEvent);
  }

  void _onGetAllScoutsEvent(GetAllScoutsEvent event, Emitter emit) async {
    emit(GetAllScoutsLoadingState());
    try{
      final scouts = await profileRepository.getScouts();
      emit(GetAllScoutsSuccessfulState(scouts));
    } catch(e) {
      emit(GetAllScoutsFailedState(e.toString()));
    }
  }

}

class PostScoutBloc extends Bloc<PostScoutEvent, PostScoutState> {

  ProfileRepository profileRepository;

  PostScoutBloc(this.profileRepository) : super(PostScoutInitialState()){
    on<CreateScoutEvent>(_onCreateScoutEvent);
  }

  void _onCreateScoutEvent(CreateScoutEvent event, Emitter emit) async {
    emit(PostScoutLoadingState());
    try{
      await profileRepository.postScout(event.scout);
      emit(PostScoutSuccessfulState());
    } catch(e) {
      emit(PostScoutFailedState(e.toString()));
    }
  }

}

class DeleteScoutBloc extends Bloc<DeleteScoutEvent, DeleteScoutState> {

  ProfileRepository profileRepository;

  DeleteScoutBloc(this.profileRepository) : super(DeleteScoutInitialState()){
    on<RemoveScoutEvent>(_onRemoveScoutEvent);
  }

  void _onRemoveScoutEvent(RemoveScoutEvent event, Emitter emit) async {
    emit(DeleteScoutLoadingState());
    try{
      await profileRepository.deleteScout(event.id);
      emit(DeleteScoutSuccessfulState());
    } catch(e) {
      emit(DeleteScoutFailedState(e.toString()));
    }
  }

}

class AgentCodeBloc extends Bloc<AgentCodeEvent, AgentCodeState> {
  ProfileRepository profileRepository;
  AgentCodeBloc(this.profileRepository) : super(AgentCodeInitialState()){
    on<RequestAgentCodeEvent>(_onRequestAgentCodeEvent);
  }

  void _onRequestAgentCodeEvent(RequestAgentCodeEvent event, Emitter emit) async {
    emit(AgentCodeLoadingState());
    try {
      await profileRepository.requestAgentCode(event.agentCode);
      emit(AgentCodeSuccessfulState());
    } catch(e) {
      emit(AgentCodeFailedState(e.toString()));
    }
  }
}

class ClientRequestBloc extends Bloc<ClientRequestEvent, ClientRequestState> {
  ProfileRepository profileRepository;
  ClientRequestBloc(this.profileRepository) : super(GetClientRequestInitialState()){
    on<GetClientRequestEvent>(_onGetClientRequestEvent);
  }

  void _onGetClientRequestEvent(GetClientRequestEvent event, Emitter emit) async {
    emit(GetClientRequestLoadingState());
    try {
      final clientRequest = await profileRepository.getClientRequest();
      emit(GetClientRequestSuccessfulState(clientRequest));
    } catch(e) {
      emit(GetClientRequestFailedState(e.toString()));
    }
  }
}

class DepositCreditBloc extends Bloc<DepositCreditEvent, DepositCreditState> {
  ProfileRepository profileRepository;
  DepositCreditBloc(this.profileRepository) : super(PostDepositCreditInitialState()){
    on<PostDepositCreditEvent>(_onPostDepositCreditEvent);
  }

  void _onPostDepositCreditEvent(PostDepositCreditEvent event, Emitter emit) async {
    emit(PostDepositCreditLoadingState());
    try {
      if(event.isAppCredit){
        await profileRepository.buyPackageWithCredit(event.amount, event.gameweeks!);
        emit(PostDepositCreditSuccessfulState(""));
        return;
      }
      String checkout_url = await profileRepository.depositCredit(event.amount, event.phoneNumber, event.autoJoin, event.isPackage, event.gameweeks);
      emit(PostDepositCreditSuccessfulState(checkout_url));
    } catch(e) {
      emit(PostDepositCreditFailedState(e.toString()));
    }
  }
}

class TransactionsHistoryBloc extends Bloc<TransactionsHistoryEvent, TransactionsHistoryState> {

  ProfileRepository profileRepository;

  TransactionsHistoryBloc(this.profileRepository) : super(GetTransactionsHistoryInitialState()){
    on<GetTransactionsHistoryEvent>(_onGetTransactionsHistoryEvent);
  }

  void _onGetTransactionsHistoryEvent(GetTransactionsHistoryEvent event, Emitter emit) async {
    emit(GetTransactionsHistoryLoadingState());
    try{
      final transactions = await profileRepository.getTransactions(event.page);
      emit(GetTransactionsHistorySuccessfulState(transactions));
    } catch(e) {
      emit(GetTransactionsHistoryFailedState(e.toString()));
    }
  }

}

class AgentTransactionsHistoryBloc extends Bloc<AgentTransactionsHistoryEvent, AgentTransactionsHistoryState> {

  ProfileRepository profileRepository;

  AgentTransactionsHistoryBloc(this.profileRepository) : super(GetAgentTransactionsHistoryInitialState()){
    on<GetAgentTransactionsHistoryEvent>(_onGetAgentTransactionsHistoryEvent);
  }

  void _onGetAgentTransactionsHistoryEvent(GetAgentTransactionsHistoryEvent event, Emitter emit) async {
    emit(GetAgentTransactionsHistoryLoadingState());
    try{
      final transactions = await profileRepository.getAgentTransactions(event.page, event.clientId);
      emit(GetAgentTransactionsHistorySuccessfulState(transactions));
    } catch(e) {
      emit(GetAgentTransactionsHistoryFailedState(e.toString()));
    }
  }

}

class WithdrawBloc extends Bloc<WithdrawEvent, WithdrawState> {

  ProfileRepository profileRepository;

  WithdrawBloc(this.profileRepository) : super(PostWithdrawInitialState()){
    on<PostWithdrawEvent>(_onPostWithdrawEvent);
  }

  void _onPostWithdrawEvent(PostWithdrawEvent event, Emitter emit) async {
    emit(PostWithdrawLoadingState());
    try{
      await profileRepository.withdraw(event.withdraw);
      emit(PostWithdrawSuccessfulState());
    } catch(e) {
      emit(PostWithdrawFailedState(e.toString()));
    }
  }

}

class BankBloc extends Bloc<BankEvent, BankState> {

  ProfileRepository profileRepository;

  BankBloc(this.profileRepository) : super(GetBankInitialState()){
    on<GetBankEvent>(_onGetBankEvent);
  }

  void _onGetBankEvent(GetBankEvent event, Emitter emit) async {
    emit(GetBankLoadingState());
    try{
      final banks = await profileRepository.getBanks();
      emit(GetBankSuccessfulState(banks));
    } catch(e) {
      emit(GetBankFailedState(e.toString()));
    }
  }

}

class AwardsBloc extends Bloc<AwardsEvent, AwardsState> {

  ProfileRepository profileRepository;

  AwardsBloc(this.profileRepository) : super(GetAwardsInitialState()){
    on<GetAwardsEvent>(_onGetAwardsEvent);
  }

  void _onGetAwardsEvent(GetAwardsEvent event, Emitter emit) async {
    emit(GetAwardsLoadingState());
    try{
      final awards = await profileRepository.getAwards(event.clientId);
      emit(GetAwardsSuccessfulState(awards));
    } catch(e) {
      emit(GetAwardsFailedState(e.toString()));
    }
  }

}

class TransferCreditBloc extends Bloc<TransferCreditEvent, TransferCreditState> {
  ProfileRepository profileRepository;
  TransferCreditBloc(this.profileRepository) : super(PostTransferCreditInitialState()){
    on<PostTransferCreditEvent>(_onPostTransferCreditEvent);
  }

  void _onPostTransferCreditEvent(PostTransferCreditEvent event, Emitter emit) async {
    emit(PostTransferCreditLoadingState());
    try {
      await profileRepository.transferCredit(event.amount, event.phoneNumber);
      emit(PostTransferCreditSuccessfulState());
    } catch(e) {
      emit(PostTransferCreditFailedState(e.toString()));
    }
  }
}

class AgentBloc extends Bloc<AgentEvent, AgentState> {

  ProfileRepository profileRepository;

  AgentBloc(this.profileRepository) : super(GetAgentInitialState()){
    on<GetAgentEvent>(_onGetAgentEvent);
  }

  void _onGetAgentEvent(GetAgentEvent event, Emitter emit) async {
    emit(GetAgentLoadingState());
    try{
      final agents = await profileRepository.getAgents(event.clientId, event.page);
      emit(GetAgentSuccessfulState(agents));
    } catch(e) {
      emit(GetAgentFailedState(e.toString()));
    }
  }

}

class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {

  ProfileRepository profileRepository;

  PackagesBloc(this.profileRepository) : super(GetPackagesInitialState()){
    on<GetPackagesEvent>(_onGetPackagesEvent);
  }

  void _onGetPackagesEvent(GetPackagesEvent event, Emitter emit) async {
    emit(GetPackagesLoadingState());
    try{
      final packages = await profileRepository.getPackages();
      emit(GetPackagesSuccessfulState(packages));
    } catch(e) {
      emit(GetPackagesFailedState(e.toString()));
    }
  }

}