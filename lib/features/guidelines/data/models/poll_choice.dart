class PollChoice {
  final String id;
  final String choice;
  final num selected_by;

  PollChoice(
      {required this.id, required this.choice, required this.selected_by});

  factory PollChoice.fromJson(Map<String, dynamic> json) =>
      PollChoice(id: json["_id"], choice: json["choice"], selected_by: json["selected_by"]);
}
