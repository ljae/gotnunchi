class Post {
  final String id;
  final String title;
  final String content;
  final String author;
  final DateTime date;
  final String regionId;
  final int commentCount;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.date,
    required this.regionId,
    required this.commentCount,
  });
}
