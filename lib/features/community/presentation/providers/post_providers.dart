import 'package:gotnunchi/features/community/data/repositories/mock_post_repository.dart';
import 'package:gotnunchi/features/community/domain/entities/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postRepositoryProvider = Provider<MockPostRepository>((ref) {
  return MockPostRepository();
});

final postsByRegionProvider = FutureProvider.family<List<Post>, String>((ref, regionId) async {
  final repository = ref.watch(postRepositoryProvider);
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));
  return repository.getPostsByRegion(regionId);
});

final postProvider = FutureProvider.family<Post?, String>((ref, postId) async {
    final repository = ref.watch(postRepositoryProvider);
     // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return repository.getPostById(postId);
});
