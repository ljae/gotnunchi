class ChatRoom {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });

  ChatRoom copyWith({
    String? id,
    String? otherUserId,
    String? otherUserName,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
