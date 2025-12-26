class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final DateTime expiresAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
