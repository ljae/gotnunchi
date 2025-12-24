import 'package:gotnunchi/core/constants/app_constants.dart';
import 'package:gotnunchi/core/widgets/app_logo_widget.dart';
import 'package:gotnunchi/features/community/presentation/providers/post_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BoardListScreen extends ConsumerWidget {
  final String regionId;

  const BoardListScreen({super.key, required this.regionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionName = AppConstants.regionNames[regionId] ?? regionId;
    final postsAsyncValue = ref.watch(postsByRegionProvider(regionId));

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppLogoWidget(),
        ),
        title: Text(regionName),
      ),
      body: postsAsyncValue.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet in this region.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    context.push('/post/${post.id}');
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              post.author,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            Text(
                              DateFormat.yMMMd().format(post.date),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.comment_outlined, size: 16, color: Colors.blueAccent),
                             const SizedBox(width: 4),
                            Text(
                              '${post.commentCount}',
                              style: const TextStyle(color: Colors.blueAccent),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create Post feature coming soon!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
