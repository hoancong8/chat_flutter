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
}
