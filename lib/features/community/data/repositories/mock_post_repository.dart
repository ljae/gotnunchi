import 'package:gotnunchi/features/community/domain/entities/post.dart';

class MockPostRepository {
  // In-memory storage for user-created posts
  final List<Post> _userPosts = [];

  List<Post> getPostsByRegion(List<String> regionIds, {PostCategory? category}) {
    List<Post> allPosts = [];

    // Add user-created posts first
    for (String regionId in regionIds) {
      final userPostsForRegion = _userPosts.where((p) => p.regionId == regionId).toList();
      allPosts.addAll(userPostsForRegion);
    }

    // Then add mock posts
    for (String regionId in regionIds) {
      allPosts.addAll(_generatePostsForRegion(regionId));
    }

    // Filter by category if provided
    if (category != null) {
      allPosts = allPosts.where((p) => p.category == category).toList();
    }

    // Sort by date (newest first)
    allPosts.sort((a, b) => b.date.compareTo(a.date));

    return allPosts;
  }

  void addPost(Post post) {
    _userPosts.add(post);
  }

  List<Post> _generatePostsForRegion(String regionId) {
    return [
      Post(
        id: '$regionId-1',
        title: 'ARC processing time at Sejongno?',
        content: 'I applied for my ARC renewal last week. Has anyone been to Sejongno office recently? How long is the processing taking these days?',
        author: 'VisaWorrier',
        authorId: 'mock-1',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        regionId: regionId,
        commentCount: 5,
        category: PostCategory.visa,
      ),
      Post(
        id: '$regionId-2',
        title: 'Moving from E-2 to F-6 visa questions',
        content: 'I am getting married soon and need to switch from E-2 to F-6. Do I need to leave the country for this?',
        author: 'LoveInKorea',
        authorId: 'mock-2',
        date: DateTime.now().subtract(const Duration(days: 1)),
        regionId: regionId,
        commentCount: 12,
        category: PostCategory.visa,
      ),
      Post(
        id: '$regionId-3',
        title: 'English speaking dentist in Gangnam?',
        content: 'I have a terrible toothache. Can anyone recommend a good dentist who speaks English near Gangnam station?',
        author: 'ToothAche',
        authorId: 'mock-3',
        date: DateTime.now().subtract(const Duration(days: 3)),
        regionId: regionId,
        commentCount: 3,
        category: PostCategory.medical,
      ),
      Post(
        id: '$regionId-4',
        title: 'Running club for beginners?',
        content: 'I want to start running. Are there any social running clubs that meet on weekends? Preferably near Han River.',
        author: 'HikerJoe',
        authorId: 'mock-4',
        date: DateTime.now().subtract(const Duration(hours: 5)),
        regionId: regionId,
        commentCount: 8,
        category: PostCategory.social,
      ),
      Post(
        id: '$regionId-5',
        title: 'Is 1000/60 reasonable for a studio here?',
        content: 'I am looking at a place near the university. They are asking for 10 million key money and 600k rent. Is this standard?',
        author: 'Newbie',
        authorId: 'mock-5',
        date: DateTime.now().subtract(const Duration(minutes: 30)),
        regionId: regionId,
        commentCount: 2,
        category: PostCategory.housing,
      ),
      Post(
        id: '$regionId-6',
        title: 'Short-term rental for 3 months',
        content: 'My parents are visiting for 3 months. Where can I find a short-term rental without a huge deposit?',
        author: 'FamilyVisit',
        authorId: 'mock-6',
        date: DateTime.now().subtract(const Duration(days: 2)),
        regionId: regionId,
        commentCount: 1,
        category: PostCategory.housing,
      ),
      Post(
        id: '$regionId-7',
        title: 'Language Exchange Partner Wanted',
        content: 'I am native English speaker looking for someone to practice Korean with. Coffee is on me!',
        author: 'K-Learner',
        authorId: 'mock-7',
        date: DateTime.now().subtract(const Duration(days: 5)),
        regionId: regionId,
        commentCount: 20,
        category: PostCategory.social,
      ),
      Post(
        id: '$regionId-8',
        title: 'How to dispose of food waste?',
        content: 'I just moved into a new villa. Do I need special bags for food waste? Where do I buy them?',
        author: 'ConfusedRecycler',
        authorId: 'mock-8',
        date: DateTime.now().subtract(const Duration(hours: 12)),
        regionId: regionId,
        commentCount: 7,
        category: PostCategory.life,
      ),
      Post(
        id: '$regionId-9',
        title: 'Setting up KakaoPay as a verify foreigner',
        content: 'I keep getting errors when trying to verify my identity on KakaoPay. My name on ARC is LAST FIRST MIDDLE. Any tips?',
        author: 'TechTrouble',
        authorId: 'mock-9',
        date: DateTime.now().subtract(const Duration(minutes: 10)),
        regionId: regionId,
        commentCount: 0,
        category: PostCategory.life,
      ),
      Post(
        id: '$regionId-10',
        title: 'Best Kimchi Jjigae in Seoul?',
        content: 'Where can I find the best Kimchi stew in town? I like it spicy and with lots of pork.',
        author: 'SpicyFood',
        authorId: 'mock-10',
        date: DateTime.now().subtract(const Duration(days: 10)),
        regionId: regionId,
        commentCount: 15,
        category: PostCategory.food,
      ),
       Post(
        id: '$regionId-11',
        title: 'Vegan restaurants recommendations',
        content: 'My friend is visiting and she is vegan. Any good recommendations for vegan-friendly Korean food?',
        author: 'GreenLife',
        authorId: 'mock-11',
        date: DateTime.now().subtract(const Duration(hours: 1)),
        regionId: regionId,
        commentCount: 4,
        category: PostCategory.food,
      ),
      Post(
        id: '$regionId-12',
        title: 'English teaching jobs for F-6 visa holder',
        content: 'I have an F-6 visa. Can I work at a Hagwon part-time? What are the requirements?',
        author: 'TeacherWannabe',
        authorId: 'mock-12',
        date: DateTime.now().subtract(const Duration(days: 4)),
        regionId: regionId,
        commentCount: 6,
        category: PostCategory.jobs,
      ),
       Post(
        id: '$regionId-13',
        title: 'Dermatologist for acne treatment',
        content: 'Looking for a skin clinic that specializes in acne treatment. English service would be a plus.',
        author: 'SkinCare',
        authorId: 'mock-13',
        date: DateTime.now().subtract(const Duration(days: 6)),
        regionId: regionId,
        commentCount: 2,
        category: PostCategory.medical,
      ),
    ];
  }

  Post? getPostById(String id) {
    // First check user-created posts
    try {
      return _userPosts.firstWhere((p) => p.id == id);
    } catch (e) {
      // If not found in user posts, extract region from post ID and search mock posts
      // Post IDs are formatted as '{regionId}-{number}' for mock posts
      final parts = id.split('-');
      if (parts.length >= 2) {
        final regionId = parts.sublist(0, parts.length - 1).join('-');
        final mockPosts = _generatePostsForRegion(regionId);
        try {
          return mockPosts.firstWhere((p) => p.id == id);
        } catch (e) {
          // Post not found in that region either
        }
      }

      // If still not found, return null
      return null;
    }
  }
}
