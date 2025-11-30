import 'package:equatable/equatable.dart';

class PaginationMeta extends Equatable {
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int itemCount;

  const PaginationMeta({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.itemCount,
  });

  bool get hasMore => currentPage < totalPages;

  @override
  List<Object?> get props => [totalItems, totalPages, currentPage, itemCount];
}

