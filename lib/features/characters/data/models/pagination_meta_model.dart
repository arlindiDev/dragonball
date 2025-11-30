import '../../domain/entities/pagination_meta.dart';

class PaginationMetaModel {
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int itemCount;

  const PaginationMetaModel({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.itemCount,
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

  PaginationMeta toEntity() {
    return PaginationMeta(
      totalItems: totalItems,
      totalPages: totalPages,
      currentPage: currentPage,
      itemCount: itemCount,
    );
  }
}

