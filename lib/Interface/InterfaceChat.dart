import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoappprovider/FirebaseService/Cloud_Firestore.dart';
import 'package:demoappprovider/CustomWidget/CustomTextField.dart';
import 'package:demoappprovider/Interface/HomeChatScreen.dart';
import 'package:flutter/material.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   ); // hoặc DefaultFirebaseOptions.currentPlatform
//   runApp(
//     MaterialApp(
//       theme: ThemeData(
//         useMaterial3: false, // Tắt Material3 nếu bạn không cần
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.white,

//           iconTheme: IconThemeData(color: Colors.black),
//           titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//       ),
//       // home: InterfaceChat(name: 'hoan', url: 'https://res.cloudinary.com/dlimibe4b/image/upload/v1746617825/cld-sample.jpg', userA: '', userB: ''),
//       home: Homechatscreen(uid: 'd'),
//       debugShowCheckedModeBanner: false,
//     ),
//   );
// }

class InterfaceChat extends StatefulWidget {
  String userA, userB, url, name;
  InterfaceChat({
    super.key,
    required this.userA,
    required this.userB,
    required this.name,
    required this.url,
  });
  @override
  State<InterfaceChat> createState() => _InterfaceChatState();
}

class _InterfaceChatState extends State<InterfaceChat> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Homechatscreen(uid: widget.userA),
                ),
              ); // Trở về màn hình trước
            },
          ),
        ),
        titleSpacing: 0,
        title: Row(
          spacing: 8,
          children: [
            ClipOval(
              child: Image.network(
                widget.url,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person_outlined,
                    size: 40,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            Text(
              widget.name,
              style: TextStyle(color: Colors.black), // <- đổi màu chữ nếu cần
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ), // <- đổi màu nút back nếu có
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('chats')
                      .doc(
                        MessagerFirestore().generateChatId(
                          widget.userA,
                          widget.userB,
                        ),
                      ) // => bạn cần có biến chatId giống trong sendMessage
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final msg = docs[index];
                    return Align(
                      alignment:
                          msg["senderId"] == widget.userA
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              msg["senderId"] == widget.userA
                                  ? Colors.grey[300]
                                  : const Color.fromARGB(255, 9, 125, 220),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(msg['text']),
                        // title: Text(items[index].value['text']),
                        // leading: Text(items[index].value['who'].toString()),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: controller,
                    name: "nhập tin nhắn ...",
                    prefixIcon: Icons.abc,
                    inputType: TextInputType.text,
                  ),
                ),
                InkWell(
                  onTap: () {
                    MessagerFirestore().sendMessage(
                      widget.userA,
                      widget.userB,
                      controller.text.toString(),
                    );
                    controller.clear();
                  },
                  child: SizedBox(
                    height: 40,
                    width: 50,
                    child: Center(child: Text("gửi")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
