import 'package:equatable/equatable.dart';

class Planet extends Equatable {
  final String name;

  const Planet({
    required this.name,
  });

  @override
  List<Object?> get props => [name];
}

