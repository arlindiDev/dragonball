import '../../domain/entities/planet.dart';

class PlanetModel extends Planet {
  const PlanetModel({
    required super.name,
  });

  factory PlanetModel.fromJson(Map<String, dynamic> json) {
    return PlanetModel(
      name: json['name'] ?? 'Unknown',
    );
  }
}

