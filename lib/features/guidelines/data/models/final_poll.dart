import 'package:fantasy/features/guidelines/data/models/poll_model.dart';
import 'package:fantasy/features/guidelines/data/models/user_poll.dart';

class FinalPoll{
  final List<PollModel> polls;
  final List<UserPoll> participatedPolls;

  FinalPoll({required this.polls, required this.participatedPolls});
}