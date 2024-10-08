class AgentTransaction {
  final String id;
  final String client_id;
  final String agent_id;
  final num amount;
  final String createdAt;
  final String updatedAt;

  AgentTransaction(
      {required this.id,
      required this.client_id,
      required this.agent_id,
      required this.amount,
      required this.createdAt,
      required this.updatedAt});

  factory AgentTransaction.fromJson(Map<String, dynamic> json) =>
      AgentTransaction(
          id: json["id"],
          client_id: json["client_id"],
          agent_id: json["agent_id"],
          amount: json["amount"],
          createdAt: json["createdAt"],
          updatedAt: json["updatedAt"]);
}
