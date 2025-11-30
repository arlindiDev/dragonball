import 'package:equatable/equatable.dart';

class Character extends Equatable {
  final int id;
  final String name;
  final String description;
  final String image;
  final String ki;
  final String maxKi;
  final String race;
  final String gender;
  final String affiliation;

  const Character({
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

  @override
  List<Object?> get props => [id, name, description, image, ki, maxKi, race, gender, affiliation];
}

