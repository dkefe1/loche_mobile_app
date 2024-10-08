class AllTimePlayerStat {
  final String id;
  final String full_name;
  final String position;
  final String tname;
  final num total_goal_scored_point;
  final num total_assist_point;
  final num total_passes_point;
  final num total_shots_on_target_point;
  final num total_cleansheet_point;
  final num total_shots_saved_point;
  final num total_penalty_saved_point;
  final num total_tacklesuccessful_point;
  final num total_yellowcard_point;
  final num total_redcard_point;
  final num total_owngoal_point;
  final num total_goalconceded_point;
  final num total_penalty_missed_point;
  final num total_interception_won_point;
  final num total_fantasy_point;
  final num total_minutes_played;
  final num total_goal_scored;
  final num total_assist;
  final num total_passes;
  final num total_shots_on_target;
  final num total_cleansheet;
  final num total_shots_saved;
  final num total_penalty_saved;
  final num total_tacklesuccessful;
  final num total_yellowcard;
  final num total_redcard;
  final num total_owngoal;
  final num total_goalconceded;
  final num total_penalty_missed;
  final num total_interception_won;

  AllTimePlayerStat({
    required this.id,
    required this.full_name,
    required this.position,
    required this.tname,
    required this.total_fantasy_point,
    required this.total_assist_point,
    required this.total_cleansheet_point,
    required this.total_goal_scored_point,
    required this.total_goalconceded_point,
    required this.total_interception_won_point,
    required this.total_owngoal_point,
    required this.total_passes_point,
    required this.total_penalty_missed_point,
    required this.total_penalty_saved_point,
    required this.total_redcard_point,
    required this.total_shots_on_target_point,
    required this.total_shots_saved_point,
    required this.total_tacklesuccessful_point,
    required this.total_yellowcard_point,
    required this.total_assist,
    required this.total_cleansheet,
    required this.total_goal_scored,
    required this.total_goalconceded,
    required this.total_interception_won,
    required this.total_minutes_played,
    required this.total_owngoal,
    required this.total_passes,
    required this.total_penalty_missed,
    required this.total_penalty_saved,
    required this.total_redcard,
    required this.total_shots_on_target,
    required this.total_shots_saved,
    required this.total_tacklesuccessful,
    required this.total_yellowcard,
  });

  factory AllTimePlayerStat.fromJson(Map<String, dynamic> json) =>
      AllTimePlayerStat(
          id: json["_id"],
          full_name: json["full_name"],
          position: json["position"],
          tname: json["tname"],
          total_fantasy_point: json["total_fantasy_point"],
          total_assist_point: json["total_assist_point"],
          total_cleansheet_point: json["total_cleansheet_point"],
          total_goal_scored_point: json["total_goal_scored_point"],
          total_goalconceded_point: json["total_goalconceded_point"],
          total_interception_won_point: json["total_interception_won_point"],
          total_owngoal_point: json["total_owngoal_point"],
          total_passes_point: json["total_passes_point"],
          total_penalty_missed_point: json["total_penalty_missed_point"],
          total_penalty_saved_point: json["total_penalty_saved_point"],
          total_redcard_point: json["total_redcard_point"],
          total_shots_on_target_point: json["total_shots_on_target_point"],
          total_shots_saved_point: json["total_shots_saved_point"],
          total_tacklesuccessful_point: json["total_tacklesuccessful_point"],
          total_yellowcard_point: json["total_yellowcard_point"],
          total_assist: json["total_assist"],
          total_cleansheet: json["total_cleansheet"],
          total_goal_scored: json["total_goal_scored"],
          total_goalconceded: json["total_goalconceded"],
          total_interception_won: json["total_interception_won"],
          total_minutes_played: json["total_minutes_played"],
          total_owngoal: json["total_owngoal"],
          total_passes: json["total_passes"],
          total_penalty_missed: json["total_penalty_missed"],
          total_penalty_saved: json["total_penalty_saved"],
          total_redcard: json["total_redcard"],
          total_shots_on_target: json["total_shots_on_target"],
          total_shots_saved: json["total_shots_saved"],
          total_tacklesuccessful: json["total_tacklesuccessful"],
          total_yellowcard: json["total_yellowcard"]);
}
