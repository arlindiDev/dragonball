import 'package:equatable/equatable.dart';

class Transformation extends Equatable {
  final String name;

  const Transformation({
    required this.name,
  });

  @override
  List<Object?> get props => [name];
}

