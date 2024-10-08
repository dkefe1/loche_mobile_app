class FeedbackTitleModel {
  final String id;
  final String title;

  FeedbackTitleModel(
      {required this.id, required this.title});

  factory FeedbackTitleModel.fromJson(Map<String, dynamic> json) =>
      FeedbackTitleModel(
          id: json["id"], title: json["title"]);
}
