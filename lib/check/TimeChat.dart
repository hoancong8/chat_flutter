import 'package:intl/intl.dart';

class Timechat {
  String formatFriendlyTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return " - Vừa xong";
    } else if (difference.inMinutes < 60) {
      return " - ${difference.inMinutes} phút trước";
    } else if (difference.inHours < 24 && time.day == now.day) {
      return " - ${difference.inHours} giờ trước";
    } else if (difference.inHours < 48 &&
        time.day == now.subtract(Duration(days: 1)).day) {
      return " - Hôm qua";
    } else {
      return  " - ${DateFormat('dd/MM').format(time)}";
    }
  }
}
