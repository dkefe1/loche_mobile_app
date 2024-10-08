abstract class LoginState {}

class InitialLoginState extends LoginState {}

class LoginSuccessfulState extends LoginState {
  final bool hasTeam;
  LoginSuccessfulState(this.hasTeam);
}

class LoginFailedState extends LoginState {
  final String error;
  LoginFailedState(this.error);
}

class LoginLoadingState extends LoginState {}

class ForgotPinSuccessfulState extends LoginState {}

class ResendOtpSuccessfulState extends LoginState {}

class ForgotPinFailedState extends LoginState {
  final String error;
  ForgotPinFailedState(this.error);
}

class ForgotPinLoadingState extends LoginState {}

class VerifyPinSuccessfulState extends LoginState {
  final String client_id;
  VerifyPinSuccessfulState(this.client_id);
}

class VerifyPinFailedState extends LoginState {
  final String error;
  VerifyPinFailedState(this.error);
}

class VerifyPinLoadingState extends LoginState {}

class ResetPinSuccessfulState extends LoginState {}

class ResetPinFailedState extends LoginState {
  final String error;
  ResetPinFailedState(this.error);
}

class ResetPinLoadingState extends LoginState {}