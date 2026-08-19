import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';

class SampleChatItem {
  final String id;
  final String sellerName;
  final String productTitle;
  final String avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final List<MessageModel> messages;

  SampleChatItem({
    required this.id,
    required this.sellerName,
    required this.productTitle,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    required this.messages,
  });

  SampleChatItem copyWith({
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    List<MessageModel>? messages,
  }) {
    return SampleChatItem(
      id: id,
      sellerName: sellerName,
      productTitle: productTitle,
      avatarUrl: avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      messages: messages ?? this.messages,
    );
  }
}

class ChatNotifier extends StateNotifier<List<SampleChatItem>> {
  ChatNotifier()
      : super([
          SampleChatItem(
            id: 'chat_1',
            sellerName: 'Javohirbek',
            productTitle: 'iPhone 15 Pro Max 256GB',
            avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80',
            lastMessage: 'Assalomu alaykum. Ha, mahsulot hali bor.',
            lastMessageTime: DateTime.now().subtract(const Duration(minutes: 12)),
            unreadCount: 1,
            messages: [
              MessageModel(
                id: 'm1',
                chatId: 'chat_1',
                senderId: 'user_me',
                text: 'Assalomu alaykum! iPhone 15 Pro Max hali sotilmadimi?',
                createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
              ),
              MessageModel(
                id: 'm2',
                chatId: 'chat_1',
                senderId: 'seller_1',
                text: 'Va alaykum assalom. Ha, mahsulot hali bor. Karobka dokumentlari to\'liq.',
                createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
              ),
            ],
          ),
          SampleChatItem(
            id: 'chat_2',
            sellerName: 'Sardorbek',
            productTitle: 'Chevrolet Cobalt 2023',
            avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=200&q=80',
            lastMessage: 'Narxidan biroz o\'tib beraman.',
            lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
            unreadCount: 0,
            messages: [
              MessageModel(
                id: 'm3',
                chatId: 'chat_2',
                senderId: 'user_me',
                text: 'Cobalt narxini kamaytirib bera olasizmi?',
                createdAt: DateTime.now().subtract(const Duration(hours: 3)),
              ),
              MessageModel(
                id: 'm4',
                chatId: 'chat_2',
                senderId: 'seller_2',
                text: 'Narxidan biroz o\'tib beraman.',
                createdAt: DateTime.now().subtract(const Duration(hours: 2)),
              ),
            ],
          ),
          SampleChatItem(
            id: 'chat_3',
            sellerName: 'Dostonbek',
            productTitle: 'BMW X5 M-Sport 2024',
            avatarUrl: 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=200&q=80',
            lastMessage: 'Salondan borib ko\'rishingiz mumkin.',
            lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
            unreadCount: 0,
            messages: [
              MessageModel(
                id: 'm5',
                chatId: 'chat_3',
                senderId: 'seller_3',
                text: 'Salondan borib ko\'rishingiz mumkin.',
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
              ),
            ],
          ),
        ]);

  void sendMessage(String chatId, String text) {
    final now = DateTime.now();
    final newMsg = MessageModel(
      id: now.millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: 'user_me',
      text: text,
      createdAt: now,
    );

    state = state.map((chat) {
      if (chat.id == chatId) {
        return chat.copyWith(
          lastMessage: text,
          lastMessageTime: now,
          messages: [...chat.messages, newMsg],
        );
      }
      return chat;
    }).toList();
  }

  void markAsRead(String chatId) {
    state = state.map((chat) {
      if (chat.id == chatId) {
        return chat.copyWith(unreadCount: 0);
      }
      return chat;
    }).toList();
  }

  String getOrCreateChatForProduct(String productId, String sellerName) {
    final existingIndex = state.indexWhere((c) => c.productTitle.contains(sellerName) || c.sellerName == sellerName);
    if (existingIndex != -1) {
      return state[existingIndex].id;
    }

    final newChatId = 'chat_${DateTime.now().millisecondsSinceEpoch}';
    final newChat = SampleChatItem(
      id: newChatId,
      sellerName: sellerName,
      productTitle: 'E\'lon bo\'yicha suhbat',
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80',
      lastMessage: 'Suhbat boshlandi',
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
      messages: [],
    );

    state = [newChat, ...state];
    return newChatId;
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<SampleChatItem>>((ref) {
  return ChatNotifier();
});
