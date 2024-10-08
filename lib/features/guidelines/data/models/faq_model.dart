class FAQModel{
  final String id;
  final String title;
  final String content;
  final bool is_published;

  FAQModel({required this.id, required this.title, required this.content, required this.is_published});

  factory FAQModel.fromJson(Map<String, dynamic> json) => FAQModel(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      is_published: json["is_published"]);
}