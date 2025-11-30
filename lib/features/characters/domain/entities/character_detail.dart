import 'package:equatable/equatable.dart';
import 'planet.dart';
import 'transformation.dart';

class CharacterDetail extends Equatable {
  final int id;
  final String name;
  final String description;
  final String image;
  final Planet? planet;
  final List<Transformation> transformations;

  const CharacterDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.planet,
    required this.transformations,
  });

  @override
  List<Object?> get props => [id, name, description, image, planet, transformations];
}

