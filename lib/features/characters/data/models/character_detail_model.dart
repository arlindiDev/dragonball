import '../../domain/entities/character_detail.dart';
import 'planet_model.dart';
import 'transformation_model.dart';

class CharacterDetailModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final String ki;
  final String maxKi;
  final String race;
  final String gender;
  final String affiliation;
  final PlanetModel? planet;
  final List<TransformationModel> transformations;

  const CharacterDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.ki,
    required this.maxKi,
    required this.race,
    required this.gender,
    required this.affiliation,
    this.planet,
    required this.transformations,
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
      planet: planet?.toEntity(),
      transformations: transformations.map((t) => t.toEntity()).toList(),
    );
  }
}

