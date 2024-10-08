class ClientRequest {
  final String id;
  final String client_id;
  final String current_job;
  final num user_traction;
  final String status;

  ClientRequest(
      {required this.id,
      required this.client_id,
      required this.current_job,
      required this.user_traction,
      required this.status});

  factory ClientRequest.fromJson(Map<String, dynamic> json) => ClientRequest(
      id: json["id"],
      client_id: json["client_id"],
      current_job: json["current_job"],
      user_traction: json["user_traction"],
      status: json["status"]);
}
