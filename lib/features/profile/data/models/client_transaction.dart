class ClientTransaction {
  final String id;
  final String client_id;
  final String transactionType;
  final num amount;
  final String createdAt;
  final String updatedAt;

  ClientTransaction(
      {required this.id,
        required this.client_id,
        required this.transactionType,
        required this.amount,
        required this.createdAt,
        required this.updatedAt});

  factory ClientTransaction.fromJson(Map<String, dynamic> json) =>
      ClientTransaction(
          id: json["id"],
          client_id: json["client_id"],
          transactionType: json["transactionType"],
          amount: json["amount"],
          createdAt: json["createdAt"],
          updatedAt: json["updatedAt"]);
}
