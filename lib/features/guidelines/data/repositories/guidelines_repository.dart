import 'package:fantasy/features/guidelines/data/datasources/remote/guidelines_remote_datasource.dart';
import 'package:fantasy/features/guidelines/data/models/about_us_model.dart';
import 'package:fantasy/features/guidelines/data/models/faq_model.dart';
import 'package:fantasy/features/guidelines/data/models/feedback_title_model.dart';
import 'package:fantasy/features/guidelines/data/models/final_poll.dart';
import 'package:fantasy/features/guidelines/data/models/injury_model.dart';
import 'package:fantasy/features/guidelines/data/models/player_selected_model.dart';
import 'package:fantasy/features/guidelines/data/models/poll_model.dart';
import 'package:fantasy/features/guidelines/data/models/privacy_model.dart';
import 'package:fantasy/features/guidelines/data/models/terms_model.dart';
import 'package:fantasy/features/guidelines/data/models/week_player_stat.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';

class GuidelinesRepository {
  GuidelinesRemoteDataSource guidelinesRemoteDataSource;
  GuidelinesRepository(this.guidelinesRemoteDataSource);

  Future<List<FAQModel>> getAllFAQs() async {
    try {
      final faqs = await guidelinesRemoteDataSource.getAllFAQs();
      return faqs;
    } catch (e) {
      throw e;
    }
  }

  Future<List<TermsModel>> getAllTerms() async {
    try {
      final terms = await guidelinesRemoteDataSource.getAllTerms();
      return terms;
    } catch (e) {
      throw e;
    }
  }

  Future<List<PrivacyModel>> getAllPolicies() async {
    try {
      final policies = await guidelinesRemoteDataSource.getAllPolicies();
      return policies;
    } catch (e) {
      throw e;
    }
  }

  Future<List<FeedbackTitleModel>> getAllFeedbaackTitle() async {
    try {
      final titles = await guidelinesRemoteDataSource.getAllFeedbackTitles();
      return titles;
    } catch (e) {
      throw e;
    }
  }

  Future postFeedback(String title, String content) async {
    try {
      await guidelinesRemoteDataSource.postFeedback(title, content);
    } catch(e) {
      throw e;
    }
  }

  Future<List<AboutUsModel>> getAboutUs() async {
    try {
      final aboutUs = await guidelinesRemoteDataSource.getAboutUs();
      return aboutUs;
    } catch (e) {
      throw e;
    }
  }

  Future<WeeklyPlayerStat> getWeeklyPlayerStat(String gameWeekId, bool isAllTime) async {
    try {
      final playerStat = await guidelinesRemoteDataSource.getWeeklyPlayerStat(gameWeekId, isAllTime);
      return playerStat;
    } catch (e) {
      throw e;
    }
  }

  Future<PlayerSelectedStat> getSelectedPlayerStat(String? gameWeekId) async {
    try {
      final playerSelectedStat = await guidelinesRemoteDataSource.getPlayerSelectedStat(gameWeekId);
      return playerSelectedStat;
    } catch (e) {
      throw e;
    }
  }

  Future<List<GameWeek>> getGameWeeks() async {
    try {
      final gameWeeks = await guidelinesRemoteDataSource.getGameWeeks();
      return gameWeeks;
    } catch (e) {
      throw e;
    }
  }

  Future<List<InjuryModel>> getInjuredPlayers(bool isLatest) async {
    try {
      final injuredPlayers = await guidelinesRemoteDataSource.getInjuredPlayers(isLatest);
      return injuredPlayers;
    } catch (e) {
      throw e;
    }
  }

  Future<FinalPoll> getPolls(String page) async {
    try {
      final polls = await guidelinesRemoteDataSource.getPolls(page);
      return polls;
    } catch (e) {
      throw e;
    }
  }

  Future patchPoll(String pol_id, String choice_id) async {
    try {
      await guidelinesRemoteDataSource.patchPoll(pol_id, choice_id);
    } catch (e) {
      throw e;
    }
  }
}