import 'package:fantasy/features/guidelines/data/models/poll_choice.dart';

class PollModel {
  final String id;
  final String question;
  final List<PollChoice> pollChoice;
  final String status;

  PollModel(
      {required this.id, required this.question, required this.pollChoice, required this.status});

  factory PollModel.fromJson(Map<String, dynamic> json) {

    List polls = json["choices"];

    return PollModel(id: json["_id"], question: json["question"], pollChoice: polls.map((poll) => PollChoice.fromJson(poll)).toList(), status: json["status"]);
  }
}
