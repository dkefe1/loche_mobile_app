import 'package:fantasy/features/auth/signup/data/datasources/remote_datasource/signup_datasource.dart';
import 'package:fantasy/features/auth/signup/data/models/signup.dart';
import 'package:fantasy/features/auth/signup/data/models/verify_otp.dart';

class SignUpRepository {
  SignUpDatasource signUpClient;
  SignUpRepository(this.signUpClient);

  Future signUp(SignUp signUp) async {
    try{
      await signUpClient.signUp(signUp);
    } catch(e){
      print(e);
      throw e;
    }
  }

  Future verifyOtp(VerifyOtp verifyOtp) async {
    try{
      await signUpClient.verifyOtp(verifyOtp);
    } catch(e){
      print(e);
      throw e;
    }
  }

  Future<bool> checkCodeAgentAvailability(String codeAgent) async {
    try {
      final isAvailable = await signUpClient.checkCodeAgentAvailability(codeAgent);
      return isAvailable;
    } catch (e) {
      throw e;
    }
  }

}