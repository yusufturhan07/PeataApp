// models/adoption_item.dart
class AdoptionItem {
  final String name;
  final String description;
  final String image;
  final String city;
  final String neighborhood;
  final String age;

  AdoptionItem({
    required this.name,
    required this.description,
    required this.image,
    required this.city,
    required this.neighborhood,
    required this.age,
  });

  factory AdoptionItem.fromJson(Map<String, dynamic> json) {
    return AdoptionItem(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      city: json['city'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      age: json['age'] ?? 0,
    );
  }
}
