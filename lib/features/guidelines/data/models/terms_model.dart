class TermsModel {
  final String id;
  final String title;
  final String content;
  final bool is_published;
  final bool is_message;
  final String createdAt;
  final String updatedAt;

  TermsModel(
      {required this.id,
      required this.title,
      required this.content,
      required this.is_published,
      required this.is_message,
      required this.createdAt,
      required this.updatedAt});

  factory TermsModel.fromJson(Map<String, dynamic> json) => TermsModel(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      is_published: json["is_published"],
      is_message: json["is_message"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);
}
