import '../../domain/entities/planet.dart';

class PlanetModel {
  final String name;

  const PlanetModel({
    required this.name,
  });

  factory PlanetModel.fromJson(Map<String, dynamic> json) {
    return PlanetModel(
      name: json['name'] ?? 'Unknown',
    );
  }

  Planet toEntity() {
    return Planet(
      name: name,
    );
  }
}

