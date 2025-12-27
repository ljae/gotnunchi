import 'package:gotnunchi/features/community/data/repositories/mock_post_repository.dart';
import 'package:gotnunchi/features/community/domain/entities/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postRepositoryProvider = Provider<MockPostRepository>((ref) {
  return MockPostRepository();
});

class PostFilter {
  final List<String> regionIds;
  final PostCategory? category;

  PostFilter({
    required this.regionIds,
    this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostFilter &&
          runtimeType == other.runtimeType &&
          regionIds.join(',') == other.regionIds.join(',') &&
          category == other.category;

  @override
  int get hashCode => regionIds.join(',').hashCode ^ category.hashCode;
}

final postsByRegionProvider = FutureProvider.family<List<Post>, PostFilter>((ref, filter) async {
  final repository = ref.read(postRepositoryProvider);

  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));

  return repository.getPostsByRegion(filter.regionIds, category: filter.category);
});

final postProvider = FutureProvider.family<Post?, String>((ref, postId) async {
    final repository = ref.watch(postRepositoryProvider);
     // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return repository.getPostById(postId);
});
