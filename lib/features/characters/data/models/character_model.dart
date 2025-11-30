import '../../domain/entities/character.dart';

class CharacterModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final String ki;
  final String maxKi;
  final String race;
  final String gender;
  final String affiliation;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.ki,
    required this.maxKi,
    required this.race,
    required this.gender,
    required this.affiliation,
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

  Character toEntity() {
    return Character(
      id: id,
      name: name,
      description: description,
      image: image,
      ki: ki,
      maxKi: maxKi,
      race: race,
      gender: gender,
      affiliation: affiliation,
    );
  }
}

