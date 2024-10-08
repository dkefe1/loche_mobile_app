import 'package:fantasy/features/auth/signup/data/models/signup.dart';
import 'package:fantasy/features/auth/signup/data/models/verify_otp.dart';

abstract class SignUpEvent {}

class PostSignUp extends SignUpEvent {
  final SignUp signUp;
  final bool isResend;
  PostSignUp(this.signUp, this.isResend);
}

class VerifyOtpEvent extends SignUpEvent {
  final VerifyOtp verifyOtp;
  VerifyOtpEvent(this.verifyOtp);
}

abstract class CodeAgentEvent {}

class CheckCodeAgentEvent extends CodeAgentEvent {
  final String codeAgent;
  CheckCodeAgentEvent(this.codeAgent);
}