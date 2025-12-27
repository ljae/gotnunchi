import 'package:gotnunchi/core/constants/app_constants.dart';
import 'package:gotnunchi/core/widgets/app_logo_widget.dart';
import 'package:gotnunchi/features/community/domain/entities/post.dart';
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

class BoardListWidget extends ConsumerStatefulWidget {
  final List<String> regionIds;
  final ScrollController? scrollController;

  const BoardListWidget({
    super.key,
    required this.regionIds,
    this.scrollController,
  });

  @override
  ConsumerState<BoardListWidget> createState() => _BoardListWidgetState();
}

class _BoardListWidgetState extends ConsumerState<BoardListWidget> {
  PostCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final filter = PostFilter(
      regionIds: widget.regionIds,
      category: _selectedCategory,
    );
    final postsAsyncValue = ref.watch(postsByRegionProvider(filter));

    return Column(
      children: [
        // Category Filter
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategoryChip(null, 'All'),
              ...PostCategory.values.map((category) => _buildCategoryChip(category, category.label)),
            ],
          ),
        ),
        const Divider(height: 1),
        // Post List
        Expanded(
          child: postsAsyncValue.when(
            data: (posts) {
              if (posts.isEmpty) {
                return const Center(child: Text('No posts yet in this category.'));
              }
              return ListView.separated(
                controller: widget.scrollController,
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
                             // Category Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                post.category.label,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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
        ),
      ],
    );
  }

  Widget _buildCategoryChip(PostCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              _selectedCategory = category;
            });
          }
        },
        selectedColor: Colors.blueAccent.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? Colors.blue[900] : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
