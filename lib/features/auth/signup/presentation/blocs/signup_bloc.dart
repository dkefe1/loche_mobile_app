import 'package:fantasy/features/auth/signup/data/repositories/signup_repository.dart';
import 'package:fantasy/features/auth/signup/presentation/blocs/signup_event.dart';
import 'package:fantasy/features/auth/signup/presentation/blocs/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpRepository signUpRepository;
  SignUpBloc(this.signUpRepository) : super(InitialSignUpState()){
    on<PostSignUp>(_onPostSignUp);
    on<VerifyOtpEvent>(_onVerifyOtpEvent);
  }

  void _onPostSignUp(PostSignUp event, Emitter emit) async {
    emit(SignUpLoading());
    try{
      await signUpRepository.signUp(event.signUp);
      if(event.isResend){
        emit(SignUpResendOtpSuccessful());
      } else {
        emit(SignUpSuccessful());
      }
    } catch(e){
      print(e);
      emit(SignUpFailed(e.toString()));
    }
  }

  void _onVerifyOtpEvent(VerifyOtpEvent event, Emitter emit) async {
    emit(VerifyOtpLoading());
    try{
      await signUpRepository.verifyOtp(event.verifyOtp);
      emit(VerifyOtpSuccessful());
    } catch(e){
      print(e);
      emit(VerifyOtpFailed(e.toString()));
    }
  }

}

class CodeAgentBloc extends Bloc<CodeAgentEvent, CodeAgentState> {

  SignUpRepository signUpRepository;

  CodeAgentBloc(this.signUpRepository) : super(CodeAgentInitialState()){
    on<CheckCodeAgentEvent>(_onCheckCodeAgentEvent);
  }

  void _onCheckCodeAgentEvent(CheckCodeAgentEvent event, Emitter emit) async {
    emit(CodeAgentLoadingState());
    try{
      final isAvailable = await signUpRepository.checkCodeAgentAvailability(event.codeAgent);
      emit(CodeAgentSuccessfulState(isAvailable));
    } catch(e) {
      emit(CodeAgentFailedState(e.toString()));
    }
  }

}