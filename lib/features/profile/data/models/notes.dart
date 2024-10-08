class Notes {
  final String id;
  final String client_id;
  final String note;
  final String createdAt;
  final String updatedAt;
  bool isEdit;
  bool isLoading;

  Notes(
      {required this.id,
      required this.client_id,
      required this.note,
      required this.createdAt,
      required this.updatedAt,
      this.isEdit = false, this.isLoading = false});

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
      id: json["_id"],
      client_id: json["client_id"],
      note: json["note"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);
}
