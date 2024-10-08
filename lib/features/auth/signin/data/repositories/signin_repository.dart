import 'package:fantasy/features/auth/signin/data/datasources/remote_datasource/signin_datasource.dart';
import 'package:fantasy/features/auth/signin/data/models/signin.dart';

class SignInRepository {
  SignInRemoteDataSource loginRemoteDataSource;
  SignInRepository(this.loginRemoteDataSource);

  Future<bool> loginClient(SignIn signIn) async {
    try {
      bool hasTeam = await loginRemoteDataSource.loginClient(signIn);
      return hasTeam;
    } catch(e) {
      throw e;
    }
  }

  Future forgotPin(String phone_number) async {
    try {
      await loginRemoteDataSource.forgotPin(phone_number);
    } catch(e) {
      throw e;
    }
  }

  Future verifyPin(String pin, String phone_number) async {
    try {
      final client_id = await loginRemoteDataSource.verifyPin(pin, phone_number);
      return client_id;
    } catch(e) {
      throw e;
    }
  }

  Future resetPin(String pin, String pin_confirm, String phone_number) async {
    try {
      await loginRemoteDataSource.resetPin(pin, pin_confirm, phone_number);
    } catch(e) {
      throw e;
    }
  }
}