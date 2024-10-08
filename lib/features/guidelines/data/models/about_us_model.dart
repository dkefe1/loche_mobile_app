class AboutUsModel {
  final String id;
  final String content;
  final String version_title;
  final String version_content;
  final String createdAt;
  final String updatedAt;

  AboutUsModel(
      {required this.id,
      required this.content,
      required this.version_title,
      required this.version_content,
      required this.createdAt,
      required this.updatedAt});

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
      id: json["id"],
      content: json["content"],
      version_title: json["version_title"],
      version_content: json["version_content"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);
}
