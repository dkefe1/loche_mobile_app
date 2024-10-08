class Stat {
  final num minutesplayed;
  final num goalscored;
  final num assist;
  final num passes;
  final num shotsontarget;
  final num cleansheet;
  final num shotssaved;
  final num penaltysaved;
  final num tacklesuccessful;
  final num yellowcard;
  final num redcard;
  final num owngoal;
  final num goalsconceded;
  final num penaltymissed;
  final num? chancecreated;
  final num? starting11;
  final num? substitute;
  final num? blockedshot;
  final num interceptionwon;
  final num? clearance;

  Stat({
    required this.minutesplayed,
    required this.goalscored,
    required this.assist,
    required this.passes,
    required this.shotsontarget,
    required this.cleansheet,
    required this.shotssaved,
    required this.penaltysaved,
    required this.tacklesuccessful,
    required this.yellowcard,
    required this.redcard,
    required this.owngoal,
    required this.goalsconceded,
    required this.penaltymissed,
    required this.chancecreated,
    required this.starting11,
    required this.substitute,
    required this.blockedshot,
    required this.interceptionwon,
    required this.clearance
  });

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
    minutesplayed: json["minutesplayed"],
    goalscored: json["goalscored"],
    assist: json["assist"],
    passes: json["passes"],
    shotsontarget: json["shotsontarget"],
    cleansheet: json["cleansheet"],
    shotssaved: json["shotssaved"],
    penaltysaved: json["penaltysaved"],
    tacklesuccessful: json["tacklesuccessful"],
    yellowcard: json["yellowcard"],
    redcard: json["redcard"],
    owngoal: json["owngoal"],
    goalsconceded: json["goalsconceded"],
    penaltymissed: json["penaltymissed"],
    chancecreated: json["chancecreated"],
    starting11: json["starting11"],
    substitute: json["substitute"],
    blockedshot: json["blockedshot"],
    interceptionwon: json["interceptionwon"],
    clearance: json["clearance"],);
}
