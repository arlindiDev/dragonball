/// Detailed character model with planet and transformations
class CharacterDetail {
  final int id;
  final String name;
  final String description;
  final String image;
  final String? planetName;
  final List<String> transformations;

  CharacterDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.planetName,
    required this.transformations,
  });

  factory CharacterDetail.fromJson(Map<String, dynamic> json) {
    // Extract transformations
    List<String> transformationsList = [];
    if (json['transformations'] != null && json['transformations'] is List) {
      transformationsList = (json['transformations'] as List)
          .map((t) => t['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    }

    // Extract planet name
    String? planet;
    if (json['originPlanet'] != null && json['originPlanet'] is Map) {
      planet = json['originPlanet']['name']?.toString();
    }

    return CharacterDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      planetName: planet,
      transformations: transformationsList,
    );
  }
}

