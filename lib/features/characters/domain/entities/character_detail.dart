import 'package:equatable/equatable.dart';
import 'planet.dart';
import 'transformation.dart';

class CharacterDetail extends Equatable {
  final int id;
  final String name;
  final String description;
  final String image;
  final String ki;
  final String maxKi;
  final String race;
  final String gender;
  final String affiliation;
  final Planet? planet;
  final List<Transformation> transformations;

  const CharacterDetail({
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

  @override
  List<Object?> get props => [id, name, description, image, ki, maxKi, race, gender, affiliation, planet, transformations];
}

