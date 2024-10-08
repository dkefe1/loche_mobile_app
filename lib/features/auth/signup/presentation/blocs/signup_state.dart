abstract class SignUpState {}

class InitialSignUpState extends SignUpState {}

class SignUpSuccessful extends SignUpState {}

class SignUpResendOtpSuccessful extends SignUpState {}

class SignUpFailed extends SignUpState {
  final String error;
  SignUpFailed(this.error);
}

class SignUpLoading extends SignUpState {}

class VerifyOtpSuccessful extends SignUpState {}

class VerifyOtpFailed extends SignUpState {
  final String error;
  VerifyOtpFailed(this.error);
}

class VerifyOtpLoading extends SignUpState {}

abstract class CodeAgentState {}

class CodeAgentInitialState extends CodeAgentState {}

class CodeAgentLoadingState extends CodeAgentState {}

class CodeAgentSuccessfulState extends CodeAgentState {
  final bool isAvailable;
  CodeAgentSuccessfulState(this.isAvailable);
}

class CodeAgentFailedState extends CodeAgentState {
  final String error;
  CodeAgentFailedState(this.error);
}

