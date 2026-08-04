/// Created by Akash Verma

import 'package:intl/intl.dart';

extension EpochExtension on String? {
  String toDateStr({String pattern = 'hh:mm a dd MMM yyyy'}) {
    if (this == null || this!.isEmpty) return "";

    return DateFormat(
      pattern,
    ).format(DateTime.fromMicrosecondsSinceEpoch(int.parse(this!)));
  }

  String toWhatsAppDate() {
    if (this == null || this!.isEmpty) return "";

    final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(this!));
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(date.year, date.month, date.day);

    final difference = today.difference(messageDay).inDays;

    if (difference == 0) {
      // Today -> 02:35 PM
      return DateFormat('hh:mm a').format(date);
    }

    if (difference == 1) {
      // Yesterday
      return "Yesterday";
    }

    // Older -> 04 Aug 2026
    return DateFormat('dd MMM yyyy').format(date);
  }
  bool isEmojiOnly() {
    final value = this?.trim();

    if (value==null||value.isEmpty) return false;

    final emojiRegex = RegExp(
      r'^(?:[\u00A9\u00AE\u203C-\u3299]|\p{Extended_Pictographic}|\u200D|\uFE0F)+$',
      unicode: true,
    );

    return emojiRegex.hasMatch(value);
  }
}
