import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/region_data.dart';
import '../../domain/entities/post.dart';
import '../providers/post_providers.dart';

class PostCreateScreen extends ConsumerStatefulWidget {
  final String? initialRegionId;

  const PostCreateScreen({super.key, this.initialRegionId});

  @override
  ConsumerState<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends ConsumerState<PostCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late String _selectedRegionId;
  PostCategory _selectedCategory = PostCategory.life; // Default category
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedRegionId = widget.initialRegionId ?? 'KR-11'; // Default to Seoul
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _selectRegion() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _RegionSelectorSheet(
        selectedRegionId: _selectedRegionId,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedRegionId = result;
      });
    }
  }

  String _getPlaceholderText() {
    switch (_selectedCategory) {
      case PostCategory.questionOnTheTown:
        return "Ask any general question about your town or neighborhood...";
      case PostCategory.visa:
        return "Ask about ARC issuance, visa extension, or documents needed...";
      case PostCategory.housing:
        return "Ask about deposit sizes, location, or contract terms...";
      case PostCategory.medical:
        return "Ask about English-speaking clinics, insurance, or pharmacies...";
      case PostCategory.life:
        return "Ask about banking, trash disposal, transportation, or general life...";
      case PostCategory.jobs:
        return "Ask about teaching jobs, labor laws, or part-time work...";
      case PostCategory.social:
        return "Ask about language exchange, hobby groups, or weekend plans...";
      case PostCategory.food:
        return "Ask about restaurant recommendations, vegan options, or recipes...";
    }
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository = ref.read(postRepositoryProvider);
      final currentUser = FirebaseAuth.instance.currentUser;

      final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        author: currentUser?.displayName ?? 'Anonymous',
        authorId: currentUser?.uid ?? 'anonymous',
        date: DateTime.now(),
        regionId: _selectedRegionId,
        commentCount: 0,
        category: _selectedCategory,
      );

      repository.addPost(newPost);

      // Invalidate the provider to refresh the feed
      // We need to invalidate the provider that might be active
      // Since provider family uses PostFilter, we can't easily invalidate ALL.
      // But usually we just refresh the screen we go back to.
      // For now, let's just let the UI refresh on next load or if we use proper Riverpod 2.0 invalidate.
      ref.invalidate(postsByRegionProvider); 

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final regionName = RegionData.getRegionName(_selectedRegionId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitPost,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Region selector
            InkWell(
              onTap: _selectRegion,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      regionName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Selector
            DropdownButtonFormField<PostCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: PostCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              maxLength: 100,
            ),
            const SizedBox(height: 16),

            // Content field
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: _getPlaceholderText(),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 10,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter content';
                }
                return null;
              },
              maxLength: 1000,
            ),
          ],
        ),
      ),
    );
  }
}

class _RegionSelectorSheet extends StatefulWidget {
  final String selectedRegionId;

  const _RegionSelectorSheet({required this.selectedRegionId});

  @override
  State<_RegionSelectorSheet> createState() => _RegionSelectorSheetState();
}

class _RegionSelectorSheetState extends State<_RegionSelectorSheet> {
  late String _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.selectedRegionId;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Region',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, _tempSelected);
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  _buildRegionSection('Seoul', RegionData.seoulDistricts),
                  _buildRegionSection('Gyeonggi', RegionData.gyeonggiDistricts),
                  // Other regions
                  _buildRegionTile('KR-26', 'Busan'),
                  _buildRegionTile('KR-27', 'Daegu'),
                  _buildRegionTile('KR-28', 'Incheon'),
                  _buildRegionTile('KR-29', 'Gwangju'),
                  _buildRegionTile('KR-30', 'Daejeon'),
                  _buildRegionTile('KR-31', 'Ulsan'),
                  _buildRegionTile('KR-50', 'Sejong'),
                  _buildRegionTile('KR-42', 'Gangwon'),
                  _buildRegionTile('KR-43', 'North Chungcheong'),
                  _buildRegionTile('KR-44', 'South Chungcheong'),
                  _buildRegionTile('KR-45', 'North Jeolla'),
                  _buildRegionTile('KR-46', 'South Jeolla'),
                  _buildRegionTile('KR-47', 'North Gyeongsang'),
                  _buildRegionTile('KR-48', 'South Gyeongsang'),
                  _buildRegionTile('KR-49', 'Jeju'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRegionSection(String title, List<Map<String, String>> districts) {
    return ExpansionTile(
      title: Text(title),
      children: districts.map((district) {
        return _buildRegionTile(district['id']!, district['nameKo']!);
      }).toList(),
    );
  }

  Widget _buildRegionTile(String regionId, String regionName) {
    final isSelected = _tempSelected == regionId;
    return RadioListTile<String>(
      title: Text(regionName),
      value: regionId,
      groupValue: _tempSelected,
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            _tempSelected = value;
          });
        }
      },
    );
  }
}
