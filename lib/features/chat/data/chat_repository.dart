import 'dart:async';
import 'package:gotnunchi/features/chat/domain/entities/message.dart';
import 'package:gotnunchi/features/chat/domain/entities/chat_room.dart';

class ChatRepository {
  // Store messages per chat room
  final Map<String, List<ChatMessage>> _messagesByRoom = {};
  final Map<String, StreamController<List<ChatMessage>>> _controllers = {};

  // Chat rooms
  final List<ChatRoom> _chatRooms = [];

  ChatRepository() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Create some mock chat rooms
    final room1 = ChatRoom(
      id: 'room1',
      otherUserId: 'user1',
      otherUserName: 'Alice Kim',
      lastMessage: 'See you at the cafe!',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 10)),
      unreadCount: 2,
    );

    final room2 = ChatRoom(
      id: 'room2',
      otherUserId: 'user2',
      otherUserName: 'Bob Lee',
      lastMessage: 'Thanks for the recommendation',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
    );

    final room3 = ChatRoom(
      id: 'room3',
      otherUserId: 'user3',
      otherUserName: 'Carol Park',
      lastMessage: 'Is the apartment still available?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
    );

    _chatRooms.addAll([room1, room2, room3]);

    // Add initial messages to room1
    _messagesByRoom['room1'] = [];
    _addMessageToRoom('room1', 'user1', 'Hello! Want to grab coffee?');
    _addMessageToRoom('room1', 'Me', 'Sure! When are you free?');
    _addMessageToRoom('room1', 'user1', 'See you at the cafe!');

    // Add initial messages to room2
    _messagesByRoom['room2'] = [];
    _addMessageToRoom('room2', 'Me', 'I recommend the bakery on Main Street');
    _addMessageToRoom('room2', 'user2', 'Thanks for the recommendation');

    // Add initial messages to room3
    _messagesByRoom['room3'] = [];
    _addMessageToRoom('room3', 'user3', 'Is the apartment still available?');
  }

  List<ChatRoom> getChatRooms() {
    // Sort by last message time
    _chatRooms.sort((a, b) {
      if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
      if (a.lastMessageTime == null) return 1;
      if (b.lastMessageTime == null) return -1;
      return b.lastMessageTime!.compareTo(a.lastMessageTime!);
    });
    return List.from(_chatRooms);
  }

  ChatRoom? getChatRoom(String roomId) {
    try {
      return _chatRooms.firstWhere((room) => room.id == roomId);
    } catch (e) {
      return null;
    }
  }

  Stream<List<ChatMessage>> getMessages(String roomId) {
    if (!_controllers.containsKey(roomId)) {
      _controllers[roomId] = StreamController<List<ChatMessage>>.broadcast();
    }
    if (!_messagesByRoom.containsKey(roomId)) {
      _messagesByRoom[roomId] = [];
    }
    _emitMessages(roomId);
    return _controllers[roomId]!.stream;
  }

  void sendMessage(String roomId, String text) {
    _addMessageToRoom(roomId, 'Me', text);
    _updateChatRoomLastMessage(roomId, text);
    _emitMessages(roomId);
  }

  void _addMessageToRoom(String roomId, String senderId, String text) {
    final now = DateTime.now();
    // 72 hours expiry
    final expiresAt = now.add(const Duration(hours: 72));

    if (!_messagesByRoom.containsKey(roomId)) {
      _messagesByRoom[roomId] = [];
    }

    _messagesByRoom[roomId]!.add(ChatMessage(
      id: '${roomId}_${now.microsecondsSinceEpoch}',
      senderId: senderId,
      content: text,
      timestamp: now,
      expiresAt: expiresAt,
    ));
  }

  void _updateChatRoomLastMessage(String roomId, String message) {
    final index = _chatRooms.indexWhere((room) => room.id == roomId);
    if (index != -1) {
      _chatRooms[index] = _chatRooms[index].copyWith(
        lastMessage: message,
        lastMessageTime: DateTime.now(),
      );
    }
  }

  void _emitMessages(String roomId) {
    if (!_messagesByRoom.containsKey(roomId)) return;
    if (!_controllers.containsKey(roomId)) return;

    // Filter out expired messages
    final now = DateTime.now();
    final validMessages = _messagesByRoom[roomId]!
        .where((msg) => msg.expiresAt.isAfter(now))
        .toList();

    // Sort by time (oldest first for chat display)
    validMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    _controllers[roomId]!.add(validMessages);
  }

  // Debug function to clear expired messages explicitly from memory
  void cleanupExpired() {
    final now = DateTime.now();
    _messagesByRoom.forEach((roomId, messages) {
      messages.removeWhere((msg) => msg.expiresAt.isBefore(now));
      _emitMessages(roomId);
    });
  }

  void dispose() {
    _controllers.values.forEach((controller) => controller.close());
  }
}
