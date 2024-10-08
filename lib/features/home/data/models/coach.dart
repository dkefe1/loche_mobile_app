class Coach{
  final String id;
  final String coach_name;
  final String image_secure_url;

  Coach({required this.id, required this.coach_name, required this.image_secure_url});

  factory Coach.fromJson(Map<String, dynamic> json) => Coach(id: json["_id"], coach_name: json["coach_name"], image_secure_url: json["image_secure_url"]);
}