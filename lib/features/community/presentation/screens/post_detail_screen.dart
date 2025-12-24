import 'package:gotnunchi/core/widgets/app_logo_widget.dart';
import 'package:gotnunchi/features/community/presentation/providers/post_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PostDetailScreen extends ConsumerWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsyncValue = ref.watch(postProvider(postId));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 110.0,
        title: const AppLogoWidget(height: 92),
        // Keep leading back button default or customize if needed
      ),
      body: postAsyncValue.when(
        data: (post) {
          if (post == null) return const Center(child: Text('Post not found'));
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        post.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const CircleAvatar(child: Icon(Icons.person)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(DateFormat.yMMMd().add_jm().format(post.date), style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        post.content,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Comments (${post.commentCount})', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      // Dummy Comments
                      _buildCommentTile('User A', 'Great info, thanks!', '2 mins ago'),
                      _buildCommentTile('User B', 'I agree with this.', '1 hour ago'),
                      if (post.commentCount > 2)
                         _buildCommentTile('User C', 'Could you clarify point 2?', '3 hours ago'),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildCommentTile(String author, String content, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            child: Text(author[0], style: const TextStyle(fontSize: 12, color: Colors.black)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(width: 8),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(content, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
