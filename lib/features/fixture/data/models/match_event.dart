import 'package:fantasy/features/fixture/data/models/match_info.dart';
import 'package:fantasy/features/fixture/data/models/match_stat.dart';

class MatchEvent{
  final List<MatchInfo> matchInfo;
  final List<MatchStat> matchStat;

  MatchEvent({required this.matchInfo, required this.matchStat});
}