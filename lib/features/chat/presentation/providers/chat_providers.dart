import 'package:gotnunchi/features/chat/data/chat_repository.dart';
import 'package:gotnunchi/features/chat/domain/entities/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

final chatMessagesProvider = StreamProvider<List<ChatMessage>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getMessages();
});
