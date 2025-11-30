/// Simple character model for list display
class Character {
  final int id;
  final String name;
  final String description;
  final String image;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

