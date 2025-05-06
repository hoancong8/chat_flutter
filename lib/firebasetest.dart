import 'package:demoappprovider/firebase_options.dart';
import 'package:demoappprovider/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //khởi tạo với cầu hình web trong firebase_options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  // DefaultFirebaseOptions.currentPlatform;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //khởi tạo tham chiếu đến node "messages"
  final dbRef = FirebaseDatabase.instance.ref("messages");

  MyApp({super.key});

  //lấy/gán dữ liệu từ textfield
  final TextEditingController _textController = TextEditingController();

  //hàm thêm tin nhắn vào realtime db
  void _addMessage(String text) {
    //push tạo 1 khóa ngẫu nhiên mới dưới node ,set ghi dữ liệu vào đó
    dbRef.push().set({'text': text});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Realtime Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Firebase Demo')),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: dbRef.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    final data = Map<String, dynamic>.from(
                      snapshot.data!.snapshot.value as Map,
                    );
                    final items = data.entries.toList();

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Align(
                          alignment: items[index].value['who'] ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  items[index].value['who']
                                      ? Colors.blue[100]
                                      : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(items[index].value['text']),
                            // title: Text(items[index].value['text']),
                            // leading: Text(items[index].value['who'].toString()),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Không có dữ liệu'));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      //lấy dữ liệu trong textfield
                      controller: _textController,

                      decoration: const InputDecoration(
                        labelText: 'Nhập tin nhắn',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        _addMessage(_textController.text);
                        _textController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
