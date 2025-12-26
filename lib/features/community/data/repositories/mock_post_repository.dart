import 'package:gotnunchi/features/community/domain/entities/post.dart';

class MockPostRepository {
  List<Post> getPostsByRegion(List<String> regionIds) {
    // Generate dummy posts.
    // In a real app, this would filter a large list or fetch from API.
    // We'll return posts that match ANY of the selected regions.
    
    // For this mock, we'll generate a few posts for each requested region
    List<Post> allPosts = [];
    
    for (String regionId in regionIds) {
       allPosts.addAll(_generatePostsForRegion(regionId));
    }

    return allPosts;
  }

  List<Post> _generatePostsForRegion(String regionId) {
    return [
      Post(
        id: '1',
        title: 'Best Cafes in this area?',
        content: 'I am looking for a quiet cafe to study. Any recommendations?',
        author: 'CoffeeLover',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        regionId: regionId,
        commentCount: 5,
      ),
      Post(
        id: '2',
        title: 'Immigration Office wait times',
        content: 'Just a heads up, the wait time is over 2 hours today.',
        author: 'VisaRunner',
        date: DateTime.now().subtract(const Duration(days: 1)),
        regionId: regionId,
        commentCount: 12,
      ),
      Post(
        id: '3',
        title: 'English speaking dentist?',
        content: 'Can anyone recommend a good dentist who speaks English?',
        author: 'ToothFairy',
        date: DateTime.now().subtract(const Duration(days: 3)),
        regionId: regionId,
        commentCount: 3,
      ),
      Post(
        id: '4',
        title: 'Meetup this weekend',
        content: 'Anyone interested in hiking this Saturday?',
        author: 'HikerJoe',
        date: DateTime.now().subtract(const Duration(hours: 5)),
        regionId: regionId,
        commentCount: 8,
      ),
      Post(
        id: '5',
        title: 'Housing Question',
        content: 'Is 500/50 a good price for a studio here?',
        author: 'Newbie',
        date: DateTime.now().subtract(const Duration(minutes: 30)),
        regionId: regionId,
        commentCount: 2,
      ),
       Post(
        id: '6',
        title: 'Second hand furniture',
        content: 'Selling my desk and chair. DM me.',
        author: 'MovingOut',
        date: DateTime.now().subtract(const Duration(days: 2)),
        regionId: regionId,
        commentCount: 1,
      ),
       Post(
        id: '7',
        title: 'Language Exchange',
        content: 'Looking for someone to practice Korean with.',
        author: 'K-Learner',
        date: DateTime.now().subtract(const Duration(days: 5)),
        regionId: regionId,
        commentCount: 20,
      ),
       Post(
        id: '8',
        title: 'Gym recommendations',
        content: 'Which gym has the best equipment?',
        author: 'GymRat',
        date: DateTime.now().subtract(const Duration(hours: 12)),
        regionId: regionId,
        commentCount: 7,
      ),
       Post(
        id: '9',
        title: 'Lost Wallet',
        content: 'I lost my wallet near the station. Has anyone seen it?',
        author: 'SadPanda',
        date: DateTime.now().subtract(const Duration(minutes: 10)),
        regionId: regionId,
        commentCount: 0,
      ),
       Post(
        id: '10',
        title: 'Best Kimchi Jjigae?',
        content: 'Where can I find the best Kimchi stew in town?',
        author: 'SpicyFood',
        date: DateTime.now().subtract(const Duration(days: 10)),
        regionId: regionId,
        commentCount: 15,
      ),
    ];
  }

  Post? getPostById(String id) {
    // Just a mocked lookup
    final allPosts = getPostsByRegion(['dummy']); 
    try {
        return allPosts.firstWhere((element) => element.id == id);
    } catch (e) {
      // Fallback if not found in list (since getPostsByRegion generates fresh ones)
      return Post(
        id: id,
        title: 'Mocked Post Detail',
        content: 'This is the detailed content of the post you clicked. In a real app, this would be fetched from a server.',
        author: 'MockAuthor',
        date: DateTime.now(),
        regionId: 'generic',
        commentCount: 0
      );
    }
  }
}
