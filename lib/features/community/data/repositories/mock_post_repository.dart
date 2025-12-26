import 'package:gotnunchi/features/community/domain/entities/post.dart';

class MockPostRepository {
  // In-memory storage for user-created posts
  final List<Post> _userPosts = [];

  List<Post> getPostsByRegion(List<String> regionIds) {
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

    // Sort by date (newest first)
    allPosts.sort((a, b) => b.date.compareTo(a.date));

    return allPosts;
  }

  void addPost(Post post) {
    _userPosts.add(post);
  }

  List<Post> _generatePostsForRegion(String regionId) {
    return [
      Post(id: '$regionId-1', title: 'Best Cafes in this area?', content: 'I am looking for a quiet cafe to study. Any recommendations?', author: 'CoffeeLover', authorId: 'mock-1', date: DateTime.now().subtract(const Duration(hours: 2)), regionId: regionId, commentCount: 5),
      Post(id: '$regionId-2', title: 'Immigration Office wait times', content: 'Just a heads up, the wait time is over 2 hours today.', author: 'VisaRunner', authorId: 'mock-2', date: DateTime.now().subtract(const Duration(days: 1)), regionId: regionId, commentCount: 12),
      Post(id: '$regionId-3', title: 'English speaking dentist?', content: 'Can anyone recommend a good dentist who speaks English?', author: 'ToothFairy', authorId: 'mock-3', date: DateTime.now().subtract(const Duration(days: 3)), regionId: regionId, commentCount: 3),
      Post(id: '$regionId-4', title: 'Meetup this weekend', content: 'Anyone interested in hiking this Saturday?', author: 'HikerJoe', authorId: 'mock-4', date: DateTime.now().subtract(const Duration(hours: 5)), regionId: regionId, commentCount: 8),
      Post(id: '$regionId-5', title: 'Housing Question', content: 'Is 500/50 a good price for a studio here?', author: 'Newbie', authorId: 'mock-5', date: DateTime.now().subtract(const Duration(minutes: 30)), regionId: regionId, commentCount: 2),
      Post(id: '$regionId-6', title: 'Second hand furniture', content: 'Selling my desk and chair. DM me.', author: 'MovingOut', authorId: 'mock-6', date: DateTime.now().subtract(const Duration(days: 2)), regionId: regionId, commentCount: 1),
      Post(id: '$regionId-7', title: 'Language Exchange', content: 'Looking for someone to practice Korean with.', author: 'K-Learner', authorId: 'mock-7', date: DateTime.now().subtract(const Duration(days: 5)), regionId: regionId, commentCount: 20),
      Post(id: '$regionId-8', title: 'Gym recommendations', content: 'Which gym has the best equipment?', author: 'GymRat', authorId: 'mock-8', date: DateTime.now().subtract(const Duration(hours: 12)), regionId: regionId, commentCount: 7),
      Post(id: '$regionId-9', title: 'Lost Wallet', content: 'I lost my wallet near the station. Has anyone seen it?', author: 'SadPanda', authorId: 'mock-9', date: DateTime.now().subtract(const Duration(minutes: 10)), regionId: regionId, commentCount: 0),
      Post(id: '$regionId-10', title: 'Best Kimchi Jjigae?', content: 'Where can I find the best Kimchi stew in town?', author: 'SpicyFood', authorId: 'mock-10', date: DateTime.now().subtract(const Duration(days: 10)), regionId: regionId, commentCount: 15),
    ];
  }

  Post? getPostById(String id) {
    final allPosts = getPostsByRegion(['dummy']);
    try {
      return allPosts.firstWhere((element) => element.id == id);
    } catch (e) {
      return Post(id: id, title: 'Mocked Post Detail', content: 'This is the detailed content of the post you clicked.', author: 'MockAuthor', authorId: 'mock-0', date: DateTime.now(), regionId: 'generic', commentCount: 0);
    }
  }
}
