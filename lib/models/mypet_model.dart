class PetModel {
  final String name;
  final String description;
  final String image;
  final String adId;
  final String age;

  PetModel(
      {required this.name,
      required this.description,
      required this.image,
      required this.adId,
      required this.age});

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      name: json['name'],
      description: json['description'],
      image: json['image'],
      adId: json['ad_id'],
      age: json['age'],
    );
  }
}
