import 'dart:async';
import 'package:gotnunchi/features/chat/domain/entities/message.dart';

class ChatRepository {
  final List<ChatMessage> _messages = [];
  final _controller = StreamController<List<ChatMessage>>.broadcast();

  ChatRepository() {
    // Add some initial dummy messages
    _addMessage('User1', 'Hello there! This message will disappear in 3 days.');
    _addMessage('User2', 'Hi! Is this chat really ephemeral?');
  }

  Stream<List<ChatMessage>> getMessages() {
    _emitMessages();
    return _controller.stream;
  }

  void sendMessage(String text) {
    _addMessage('Me', text);
    _emitMessages();
  }

  void _addMessage(String senderId, String text) {
    final now = DateTime.now();
    // 72 hours expiry
    final expiresAt = now.add(const Duration(hours: 72));
    
    _messages.add(ChatMessage(
      id: now.microsecondsSinceEpoch.toString(),
      senderId: senderId,
      content: text,
      timestamp: now,
      expiresAt: expiresAt,
    ));
  }

  void _emitMessages() {
    // Filter out expired messages
    final now = DateTime.now();
    final validMessages = _messages.where((msg) => msg.expiresAt.isAfter(now)).toList();
    
    // Sort by time
    validMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    _controller.add(validMessages);
  }

  // Debug function to clear expired messages explicitly from memory
  void cleanupExpired() {
    final now = DateTime.now();
    _messages.removeWhere((msg) => msg.expiresAt.isBefore(now));
    _emitMessages();
  }
}
