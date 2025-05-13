import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoappprovider/FirebaseService/Cloud_Firestore.dart';
import 'package:demoappprovider/CustomWidget/CustomTextField.dart';
import 'package:flutter/material.dart';

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
        leading: ClipOval(
          child: Image.network(
            widget.url,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(widget.name),
        backgroundColor: Colors.white,
        elevation: 10,
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
                                  ? const Color.fromARGB(255, 9, 125, 220)
                                  : Colors.grey[300],
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

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: controller,
                      name: "mess",
                      prefixIcon: Icons.abc,
                      inputType: TextInputType.text,
                    ),
                  ),
                ),
              

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    MessagerFirestore().sendMessage(
                      widget.userA,
                      widget.userB,
                      controller.text.toString(),
                    );
                  },
                  child: Text("gửi"),
                ),
              ),

              
            ],
          ),
        ],
      ),
    );
  }
}
