
import 'package:firebase_database/firebase_database.dart';

enum MessageType {
  text,
  image,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class MessageItem {
  final String? conversationId;
  final String msgId;
  final String senderId;
  final String text;
  final MessageType type;
  final num timestamp;
  final MessageStatus status;
  final String? replyToMessageId;
  final String? replyToText;
  final String? reaction;

  const MessageItem({
    this.conversationId,
    required this.msgId,
    required this.senderId,
    required this.text,
    required this.type,
    required this.timestamp,
    required this.status,
    this.replyToMessageId,
    this.replyToText,
    this.reaction,
  });

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'msgId': msgId,
      'senderId': senderId,
      'text': text,
      'type': type.name,
      'timestamp': timestamp,
      'status': status.name,
      'replyToMessageId': replyToMessageId,
      'replyToText': replyToText,
      'reaction': reaction,
    };
  }

  factory MessageItem.fromJson(Map<dynamic, dynamic> json) {
    return MessageItem(
      replyToMessageId: json['replyToMessageId']?.toString(),
      replyToText: json['replyToText']?.toString(),
      conversationId: json['conversationId']  ,
      msgId: json['msgId'] ?? '',
      senderId: json['senderId'] ?? '',
      text: json['text'] ?? '',
      type: MessageType.values.firstWhere(
            (type) => type.name == json['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: json['timestamp'] is num
          ? json['timestamp'] as num
          : num.tryParse(json['timestamp']?.toString() ?? '') ?? 0,
      status: MessageStatus.values.firstWhere(
            (status) => status.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      reaction: json['reaction'],
    );
  }

  factory MessageItem.fromSnapshot(DataSnapshot snapshot) {
    final value = snapshot.value;

    if (value is! Map) {
      throw const FormatException('Invalid Firebase message data');
    }

    final json = Map<dynamic, dynamic>.from(value);

    return MessageItem(
      replyToMessageId: json['replyToMessageId']?.toString(),
      replyToText: json['replyToText']?.toString(),
      conversationId: json['conversationId'] ,
      msgId: json['msgId']  ?? snapshot.key ?? '',
      senderId: json['senderId']  ?? '',
      text: json['text'] ?? '',
      type: MessageType.values.firstWhere(
            (type) => type.name == json['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: json['timestamp'] is num
          ? json['timestamp'] as num
          : num.tryParse(json['timestamp']?.toString() ?? '') ?? 0,
      status: MessageStatus.values.firstWhere(
            (status) => status.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      reaction: json['reaction'],
    );
  }
}
