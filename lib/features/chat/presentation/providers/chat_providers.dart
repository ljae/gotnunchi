import 'package:gotnunchi/features/chat/data/chat_repository.dart';
import 'package:gotnunchi/features/chat/domain/entities/message.dart';
import 'package:gotnunchi/features/chat/domain/entities/chat_room.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

// Provider for chat rooms list
final chatRoomsProvider = Provider<List<ChatRoom>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getChatRooms();
});

// Provider for messages in a specific chat room
final chatMessagesProvider = StreamProvider.family<List<ChatMessage>, String>((ref, roomId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getMessages(roomId);
});

// Provider for a specific chat room
final chatRoomProvider = Provider.family<ChatRoom?, String>((ref, roomId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getChatRoom(roomId);
});
