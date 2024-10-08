import 'package:fantasy/features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:fantasy/features/profile/data/models/agent_code.dart';
import 'package:fantasy/features/profile/data/models/agent_transaction.dart';
import 'package:fantasy/features/profile/data/models/agents.dart';
import 'package:fantasy/features/profile/data/models/awards.dart';
import 'package:fantasy/features/profile/data/models/bank.dart';
import 'package:fantasy/features/profile/data/models/client_request.dart';
import 'package:fantasy/features/profile/data/models/notes.dart';
import 'package:fantasy/features/profile/data/models/package.dart';
import 'package:fantasy/features/profile/data/models/profile.dart';
import 'package:fantasy/features/profile/data/models/profile_section.dart';
import 'package:fantasy/features/profile/data/models/scout.dart';
import 'package:fantasy/features/profile/data/models/transaction_history.dart';
import 'package:fantasy/features/profile/data/models/update_pin.dart';
import 'package:fantasy/features/profile/data/models/update_profile.dart';
import 'package:fantasy/features/profile/data/models/withdraw.dart';

class ProfileRepository {
  ProfileRemoteDataSource profileRemoteDataSource;
  ProfileRepository(this.profileRemoteDataSource);

  Future<ProfileSection> getProfile() async {
    try {
      final profile = await profileRemoteDataSource.getProfile();
      return profile;
    } catch (e) {
      throw e;
    }
  }

  Future updateProfile(UpdateProfile updateProfile) async {
    try {
      await profileRemoteDataSource.updateProfile(updateProfile);
    } catch(e) {
      throw e;
    }
  }

  Future patchPin(UpdatePin updatePin) async {
    try {
      await profileRemoteDataSource.patchPin(updatePin);
    } catch(e) {
      throw e;
    }
  }

  Future patchProPic(String id, String url) async {
    try {
      await profileRemoteDataSource.patchProPic(id, url);
    } catch(e) {
      throw e;
    }
  }

  Future<List<Notes>> getNotes() async {
    try {
      final notes = await profileRemoteDataSource.getNotes();
      return notes;
    } catch (e) {
      throw e;
    }
  }

  Future postNote(String note) async {
    try {
      await profileRemoteDataSource.postNote(note);
    } catch(e) {
      throw e;
    }
  }

  Future patchNote(String id, String note) async {
    try {
      await profileRemoteDataSource.patchNote(id, note);
    } catch(e) {
      throw e;
    }
  }

  Future deleteNote(String id) async {
    try {
      await profileRemoteDataSource.deleteNote(id);
    } catch(e) {
      throw e;
    }
  }

  Future deleteAllNote() async {
    try {
      await profileRemoteDataSource.deleteAllNote();
    } catch(e) {
      throw e;
    }
  }

  Future<List<Scout>> getScouts() async {
    try {
      final scouts = await profileRemoteDataSource.getScouts();
      return scouts;
    } catch (e) {
      throw e;
    }
  }

  Future postScout(Scout scout) async {
    try {
      await profileRemoteDataSource.postScout(scout);
    } catch(e) {
      throw e;
    }
  }

  Future deleteScout(String id) async {
    try {
      await profileRemoteDataSource.deleteScout(id);
    } catch(e) {
      throw e;
    }
  }

  Future requestAgentCode(AgentCode agentCode) async {
    try {
      await profileRemoteDataSource.requestAgentCode(agentCode);
    } catch(e) {
      throw e;
    }
  }

  Future<ClientRequest?> getClientRequest() async {
    try {
      final clientRequest = await profileRemoteDataSource.getClientRequest();
      return clientRequest;
    } catch (e) {
      throw e;
    }
  }

  Future<String> depositCredit(num amount, String phoneNumber, bool autoJoin, bool isPackage, num? gameweeks) async {
    try {
      final checkout_url = await profileRemoteDataSource.depositCredit(amount, phoneNumber, autoJoin, isPackage, gameweeks);
      return checkout_url;
    } catch(e) {
      throw e;
    }
  }

  Future<List<TransactionHistory>> getTransactions(String page) async {
    try {
      final transactions = await profileRemoteDataSource.getTransactions(page);
      return transactions;
    } catch (e) {
      throw e;
    }
  }

  Future<List<AgentTransaction>> getAgentTransactions(String page, String clientId) async {
    try {
      final transactions = await profileRemoteDataSource.getAgentTransactions(page, clientId);
      return transactions;
    } catch (e) {
      throw e;
    }
  }

  Future withdraw(Withdraw withdraw) async {
    try {
      await profileRemoteDataSource.withdraw(withdraw);
    } catch(e) {
      throw e;
    }
  }

  Future<List<Bank>> getBanks() async {
    try {
      final banks = await profileRemoteDataSource.getBanks();
      return banks;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Awards>> getAwards(String clientId) async {
    try {
      final awards = await profileRemoteDataSource.getAwards(clientId);
      return awards;
    } catch (e) {
      throw e;
    }
  }

  Future transferCredit(num amount, String phoneNumber) async {
    try {
      await profileRemoteDataSource.transferCredit(amount, phoneNumber);
    } catch(e) {
      throw e;
    }
  }

  Future<List<Agents>> getAgents(String clientId, String page) async {
    try {
      final agents = await profileRemoteDataSource.getAgents(clientId, page);
      return agents;
    } catch (e) {
      throw e;
    }
  }

  Future<List<PackageModel>> getPackages() async {
    try {
      final packages = await profileRemoteDataSource.getPackages();
      return packages;
    } catch (e) {
      throw e;
    }
  }

  Future buyPackageWithCredit(num amount, num gameweeks) async {
    try {
      final packages = await profileRemoteDataSource.buyPackageWithCredit(amount, gameweeks);
    } catch (e) {
      throw e;
    }
  }
}