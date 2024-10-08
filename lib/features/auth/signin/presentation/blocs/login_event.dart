import 'package:fantasy/features/auth/signin/data/models/signin.dart';

abstract class LoginEvent {}

class LoginClient extends LoginEvent {
  final SignIn signIn;
  LoginClient(this.signIn);
}

class ForgotPin extends LoginEvent {
  final String phone_number;
  final bool isResendOtp;
  ForgotPin(this.phone_number, this.isResendOtp);
}

class VerifyPin extends LoginEvent {
  final String pin;
  final String phone_number;
  VerifyPin(this.pin, this.phone_number);
}

class ResetPin extends LoginEvent {
  final String pin, pin_confirm, phone_number;
  ResetPin(this.pin, this.pin_confirm, this.phone_number);
}