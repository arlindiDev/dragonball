import '../../domain/entities/transformation.dart';

class TransformationModel {
  final String name;

  const TransformationModel({
    required this.name,
  });

  factory TransformationModel.fromJson(Map<String, dynamic> json) {
    return TransformationModel(
      name: json['name'] ?? '',
    );
  }

  Transformation toEntity() {
    return Transformation(
      name: name,
    );
  }
}

