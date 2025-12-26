import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post.dart';

class FirebasePostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'posts';

  // Get posts by region IDs
  Stream<List<Post>> getPostsByRegionStream(List<String> regionIds) {
    return _firestore
        .collection(_collectionName)
        .where('regionId', whereIn: regionIds)
        .orderBy('date', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    });
  }

  // Get posts by region IDs (Future)
  Future<List<Post>> getPostsByRegion(List<String> regionIds) async {
    if (regionIds.isEmpty) return [];

    final snapshot = await _firestore
        .collection(_collectionName)
        .where('regionId', whereIn: regionIds)
        .orderBy('date', descending: true)
        .limit(50)
        .get();

    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

  // Get single post by ID
  Future<Post?> getPostById(String postId) async {
    final doc = await _firestore.collection(_collectionName).doc(postId).get();

    if (!doc.exists) return null;

    return Post.fromFirestore(doc);
  }

  // Add new post
  Future<void> addPost(Post post) async {
    await _firestore.collection(_collectionName).add(post.toFirestore());
  }

  // Update post
  Future<void> updatePost(Post post) async {
    await _firestore
        .collection(_collectionName)
        .doc(post.id)
        .update(post.toFirestore());
  }

  // Delete post
  Future<void> deletePost(String postId) async {
    await _firestore.collection(_collectionName).doc(postId).delete();
  }

  // Get posts by author
  Future<List<Post>> getPostsByAuthor(String authorId) async {
    final snapshot = await _firestore
        .collection(_collectionName)
        .where('authorId', isEqualTo: authorId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }
}
