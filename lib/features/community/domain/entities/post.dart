import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final String author;
  final String authorId;
  final DateTime date;
  final String regionId;
  final int commentCount;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.authorId,
    required this.date,
    required this.regionId,
    required this.commentCount,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'author': author,
      'authorId': authorId,
      'date': Timestamp.fromDate(date),
      'regionId': regionId,
      'commentCount': commentCount,
    };
  }

  // Create from Firestore document
  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      author: data['author'] ?? 'Unknown',
      authorId: data['authorId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      regionId: data['regionId'] ?? '',
      commentCount: data['commentCount'] ?? 0,
    );
  }
}
