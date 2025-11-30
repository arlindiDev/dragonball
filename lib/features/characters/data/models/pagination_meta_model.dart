import '../../domain/entities/pagination_meta.dart';

class PaginationMetaModel extends PaginationMeta {
  const PaginationMetaModel({
    required super.totalItems,
    required super.totalPages,
    required super.currentPage,
    required super.itemCount,
  });

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return PaginationMetaModel(
      totalItems: json['totalItems'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 1,
      currentPage: json['currentPage'] as int? ?? 1,
      itemCount: json['itemCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'itemCount': itemCount,
    };
  }
}

