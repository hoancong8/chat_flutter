import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoappprovider/CustomWidget/CustomTextField.dart';
import 'package:flutter/material.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
//   runApp(MaterialApp(home: CloudFirestore()));
// }

class MessagerFirestore {
  String generateChatId(String userA, String userB) {
    // Đảm bảo luôn theo thứ tự để tránh bị trùng 2 chiều (A_B vs B_A)
    List<String> users = [userA, userB];
    users.sort();
    return '${users[0]}_${users[1]}';
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void sendMessage(String userA, String userB, String text) {
    String chatId = generateChatId(userA, userB);
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    // Gửi tin nhắn
    chatRef.collection('messages').add({
      'text': text,
      'senderId': userA,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Cập nhật thông tin cuộc trò chuyện
    chatRef.set({
      'members': [userA, userB],
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Object?> getLastMessage(String userA, String userB) async {
    try {
      // Sắp xếp ID để đúng thứ tự userA_userB
      final chatId = generateChatId(userA, userB);
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .orderBy(
                'timestamp',
                descending: true,
              ) // timestamp là thời gian gửi
              .limit(1) // chỉ lấy tin nhắn mới nhất
              .get();
      // Truy cập document trong collection 'chats'
      if (querySnapshot.docs.isNotEmpty) {
        final lastMsg = querySnapshot.docs.first;
        // print("hiihihhi121311${lastMsg.data()}");
        // final timestamp = lastMsg['timestamp'] as Timestamp;
        // final dateTime = timestamp.toDate(); // Chuyển thành DateTime
        // final formattedTime =
        //     "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

        // if (lastMsg['senderId'] == userA) {
          return querySnapshot.docs.first;
        // } else {
        //   return "${lastMsg['text']}${formattedTime}" ?? '';
        // }
        // 'content' là trường chứa nội dung tin nhắn
      // } else {
      //   return null; // không có tin nhắn
      }
    } catch (e) {
      print('Lỗi khi lấy lastMessage: $e');
      return null;
    }
  }
}
