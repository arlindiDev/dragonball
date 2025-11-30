import 'package:flutter/material.dart';

class PaginatedScrollView extends StatefulWidget {
  final Widget child;
  final VoidCallback onLoadMore;
  final bool isLoading;
  final bool hasMore;
  final ScrollController? scrollController;
  
  final double loadMoreThreshold;

  const PaginatedScrollView({
    super.key,
    required this.child,
    required this.onLoadMore,
    required this.isLoading,
    required this.hasMore,
    this.scrollController,
    this.loadMoreThreshold = 0.8,
  }) : assert(loadMoreThreshold > 0.0 && loadMoreThreshold <= 1.0);

  @override
  State<PaginatedScrollView> createState() => _PaginatedScrollViewState();
}

class _PaginatedScrollViewState extends State<PaginatedScrollView> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;
  bool _ownsScrollController = false;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      _scrollController = widget.scrollController!;
    } else {
      _scrollController = ScrollController();
      _ownsScrollController = true;
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(PaginatedScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.isLoading && !widget.isLoading) {
      _resetLoadingFlag();
    }
    
    if (oldWidget.scrollController != widget.scrollController) {
      _scrollController.removeListener(_onScroll);
      
      if (_ownsScrollController) {
        _scrollController.dispose();
      }
      
      if (widget.scrollController != null) {
        _scrollController = widget.scrollController!;
        _ownsScrollController = false;
      } else {
        _scrollController = ScrollController();
        _ownsScrollController = true;
      }
      
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if (_ownsScrollController) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore || widget.isLoading || !widget.hasMore) {
      return;
    }
    
    final scrollPosition = _scrollController.position.pixels;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final threshold = maxScrollExtent * widget.loadMoreThreshold;
    
    if (scrollPosition >= threshold) {
      _isLoadingMore = true;
      widget.onLoadMore();
    }
  }

  void _resetLoadingFlag() {
    if (_isLoadingMore) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

