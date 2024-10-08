class Advertisement {
  final String id;
  final String company_name;
  final String website_url;
  final String imagePath;
  final String start_date;
  final String expire_date;

  Advertisement(
      {required this.id,
      required this.company_name,
      required this.website_url,
      required this.imagePath,
      required this.start_date,
      required this.expire_date});

  factory Advertisement.fromJson(Map<String, dynamic> json) => Advertisement(
      id: json["_id"],
      company_name: json["ad_company"]["comp_name"],
      website_url: json["link"] ?? "",
      // imagePath: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkGFVZUIZfS0DqtDbJdFT9fld-8aFJXT2SoA&usqp=CAU",
      imagePath: json["img"]["cloudinary_secure_url"],
      start_date: json["start_date"],
      expire_date: json["end_date"]);
}
