class AppUpdate {
  final String id;
  final String latest_version;
  final String url;
  final String os;
  final bool highly_severe;
  final String createdAt;
  final String updatedAt;

  AppUpdate(
      {required this.id,
      required this.latest_version,
      required this.url,
      required this.os,
      required this.highly_severe,
      required this.createdAt,
      required this.updatedAt});

  factory AppUpdate.fromJson(Map<String, dynamic> json) => AppUpdate(
      id: json["id"],
      latest_version: json["latest_version"],
      url: json["url"],
      os: json["os"],
      highly_severe: json["highly_severe"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);
}
