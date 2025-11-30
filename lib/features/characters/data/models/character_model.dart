import '../../domain/entities/character.dart';

class CharacterModel extends Character {
  const CharacterModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
    required super.ki,
    required super.maxKi,
    required super.race,
    required super.gender,
    required super.affiliation,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      ki: json['ki'] ?? '0',
      maxKi: json['maxKi'] ?? '0',
      race: json['race'] ?? 'Unknown',
      gender: json['gender'] ?? 'Unknown',
      affiliation: json['affiliation'] ?? 'Unknown',
    );
  }
}

