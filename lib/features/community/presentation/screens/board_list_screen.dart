import 'package:gotnunchi/core/constants/app_constants.dart';
import 'package:gotnunchi/core/widgets/app_logo_widget.dart';
import 'package:gotnunchi/features/community/presentation/providers/post_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BoardListScreen extends StatelessWidget {
  final String regionId;

  const BoardListScreen({super.key, required this.regionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 140.0,
        title: const AppLogoWidget(height: 92),
      ),
      body: BoardListWidget(regionIds: [regionId]),
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

class BoardListWidget extends ConsumerWidget {
  final List<String> regionIds;
  final ScrollController? scrollController;

  const BoardListWidget({
    super.key, 
    required this.regionIds,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionIdsString = regionIds.join(',');
    final postsAsyncValue = ref.watch(postsByRegionProvider(regionIdsString));

    return postsAsyncValue.when(
      data: (posts) {
        if (posts.isEmpty) {
          // Even if empty, we might want to allow scrolling if inside a draggable sheet
          // so the user can drag it down? 
          // But standard behavior for draggable sheet is that the LIST needs to be scrollable.
          // If empty, we usually show a non-scrollable message. 
          // The sheet handle is outside, so dragging down is fine via handle.
          return const Center(child: Text('No posts yet in this region.'));
        }
        return ListView.separated(
          controller: scrollController,
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
    );
  }
}
