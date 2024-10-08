class UserPoll {
  final String id;
  final String choice_id;
  final String pol_id;

  UserPoll({required this.id, required this.choice_id, required this.pol_id});

  factory UserPoll.fromJson(Map<String, dynamic> json) => UserPoll(
      id: json["_id"],
      choice_id: json["choice_id"],
      pol_id: json["poll_id"]["_id"]);
}
