import '../../domain/entities/character_detail.dart';
import 'planet_model.dart';
import 'transformation_model.dart';

class CharacterDetailModel extends CharacterDetail {
  const CharacterDetailModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
    required super.ki,
    required super.maxKi,
    required super.race,
    required super.gender,
    required super.affiliation,
    super.planet,
    required super.transformations,
  });

  factory CharacterDetailModel.fromJson(Map<String, dynamic> json) {
    List<TransformationModel> transformationsList = [];
    if (json['transformations'] != null && json['transformations'] is List) {
      transformationsList = (json['transformations'] as List)
          .map((t) => TransformationModel.fromJson(t))
          .where((t) => t.name.isNotEmpty)
          .toList();
    }

    PlanetModel? planet;
    if (json['originPlanet'] != null && json['originPlanet'] is Map) {
      planet = PlanetModel.fromJson(json['originPlanet']);
    }

    return CharacterDetailModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      ki: json['ki'] ?? '0',
      maxKi: json['maxKi'] ?? '0',
      race: json['race'] ?? 'Unknown',
      gender: json['gender'] ?? 'Unknown',
      affiliation: json['affiliation'] ?? 'Unknown',
      planet: planet,
      transformations: transformationsList,
    );
  }

  CharacterDetail toEntity() {
    return CharacterDetail(
      id: id,
      name: name,
      description: description,
      image: image,
      ki: ki,
      maxKi: maxKi,
      race: race,
      gender: gender,
      affiliation: affiliation,
      planet: planet,
      transformations: transformations,
    );
  }
}

