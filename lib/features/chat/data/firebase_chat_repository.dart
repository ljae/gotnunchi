import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/entities/chat_room.dart';
import '../domain/entities/message.dart';

class FirebaseChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all chat rooms for current user
  Stream<List<ChatRoom>> getChatRoomsStream(String currentUserId) {
    return _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final participants = List<String>.from(data['participants'] ?? []);
        final otherUserId =
            participants.firstWhere((id) => id != currentUserId, orElse: () => '');

        return ChatRoom(
          id: doc.id,
          otherUserId: otherUserId,
          otherUserName: data['otherUserName'] ?? 'Unknown',
          lastMessage: data['lastMessage'],
          lastMessageTime: data['lastMessageTime'] != null
              ? (data['lastMessageTime'] as Timestamp).toDate()
              : null,
          unreadCount: data['unreadCount_$currentUserId'] ?? 0,
        );
      }).toList();
    });
  }

  // Get specific chat room
  Future<ChatRoom?> getChatRoom(String roomId, String currentUserId) async {
    final doc = await _firestore.collection('chatRooms').doc(roomId).get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    final participants = List<String>.from(data['participants'] ?? []);
    final otherUserId =
        participants.firstWhere((id) => id != currentUserId, orElse: () => '');

    return ChatRoom(
      id: doc.id,
      otherUserId: otherUserId,
      otherUserName: data['otherUserName'] ?? 'Unknown',
      lastMessage: data['lastMessage'],
      lastMessageTime: data['lastMessageTime'] != null
          ? (data['lastMessageTime'] as Timestamp).toDate()
          : null,
      unreadCount: data['unreadCount_$currentUserId'] ?? 0,
    );
  }

  // Get messages for a chat room (with 72-hour expiry filter)
  Stream<List<ChatMessage>> getMessagesStream(String roomId) {
    final now = DateTime.now();
    final expiryThreshold = Timestamp.fromDate(now);

    return _firestore
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .where('expiresAt', isGreaterThan: expiryThreshold)
        .orderBy('expiresAt')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatMessage(
          id: doc.id,
          senderId: data['senderId'] ?? '',
          content: data['content'] ?? '',
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          expiresAt: (data['expiresAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  // Send message
  Future<void> sendMessage(
    String roomId,
    String senderId,
    String content,
  ) async {
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(hours: 72));

    final messageData = {
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(now),
      'expiresAt': Timestamp.fromDate(expiresAt),
    };

    // Add message to subcollection
    await _firestore
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .add(messageData);

    // Update chat room's last message
    await _firestore.collection('chatRooms').doc(roomId).update({
      'lastMessage': content,
      'lastMessageTime': Timestamp.fromDate(now),
    });
  }

  // Create new chat room
  Future<String> createChatRoom({
    required String currentUserId,
    required String otherUserId,
    required String otherUserName,
  }) async {
    // Check if chat room already exists
    final existingRoom = await _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: currentUserId)
        .get();

    for (var doc in existingRoom.docs) {
      final participants = List<String>.from(doc.data()['participants'] ?? []);
      if (participants.contains(otherUserId)) {
        return doc.id; // Return existing room ID
      }
    }

    // Create new room
    final roomData = {
      'participants': [currentUserId, otherUserId],
      'otherUserName': otherUserName,
      'lastMessage': null,
      'lastMessageTime': null,
      'unreadCount_$currentUserId': 0,
      'unreadCount_$otherUserId': 0,
      'createdAt': Timestamp.now(),
    };

    final docRef = await _firestore.collection('chatRooms').add(roomData);
    return docRef.id;
  }

  // Delete expired messages (can be called manually or via Cloud Function)
  Future<void> deleteExpiredMessages() async {
    final now = Timestamp.now();
    final roomsSnapshot = await _firestore.collection('chatRooms').get();

    for (var roomDoc in roomsSnapshot.docs) {
      final messagesRef = roomDoc.reference.collection('messages');
      final expiredMessages = await messagesRef
          .where('expiresAt', isLessThanOrEqualTo: now)
          .get();

      final batch = _firestore.batch();
      for (var doc in expiredMessages.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    }
  }
}
