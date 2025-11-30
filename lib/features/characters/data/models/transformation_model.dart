import '../../domain/entities/transformation.dart';

class TransformationModel extends Transformation {
  const TransformationModel({
    required super.name,
  });

  factory TransformationModel.fromJson(Map<String, dynamic> json) {
    return TransformationModel(
      name: json['name'] ?? '',
    );
  }

  Transformation toEntity() {
    return Transformation(name: name);
  }
}

