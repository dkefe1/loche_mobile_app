import 'package:fantasy/features/auth/signin/data/repositories/signin_repository.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_event.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  SignInRepository loginRepository;
  LoginBloc(this.loginRepository) : super(InitialLoginState()){
    on<LoginClient>(_onLoginClient);
    on<ForgotPin>(_onForgotPin);
    on<VerifyPin>(_onVerifyPin);
    on<ResetPin>(_onResetPin);
  }

  void _onLoginClient(LoginClient event, Emitter emit) async {
    emit(LoginLoadingState());
    try {
      final hasTeam = await loginRepository.loginClient(event.signIn);
      emit(LoginSuccessfulState(hasTeam));
    } catch (e) {
      emit(LoginFailedState(e.toString()));
    }
  }

  void _onForgotPin(ForgotPin event, Emitter emit) async {
    emit(ForgotPinLoadingState());
    try {
      await loginRepository.forgotPin(event.phone_number);
      if(event.isResendOtp){
        emit(ResendOtpSuccessfulState());
      } else{
        emit(ForgotPinSuccessfulState());
      }
    } catch (e) {
      emit(ForgotPinFailedState(e.toString()));
    }
  }

  void _onVerifyPin(VerifyPin event, Emitter emit) async {
    emit(VerifyPinLoadingState());
    try {
      final client_id = await loginRepository.verifyPin(event.pin, event.phone_number);
      emit(VerifyPinSuccessfulState(client_id));
    } catch (e) {
      emit(VerifyPinFailedState(e.toString()));
    }
  }

  void _onResetPin(ResetPin event, Emitter emit) async {
    emit(ResetPinLoadingState());
    try {
      await loginRepository.resetPin(event.pin, event.pin_confirm, event.phone_number);
      emit(ResetPinSuccessfulState());
    } catch (e) {
      emit(ResetPinFailedState(e.toString()));
    }
  }
}