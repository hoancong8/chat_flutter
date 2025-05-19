import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_url_gen/transformation/background/background.dart';
import 'package:demoappprovider/FirebaseService/AuthService.dart';
import 'package:demoappprovider/FirebaseService/Cloud_Firestore.dart';
import 'package:demoappprovider/Interface/InterfaceChat.dart';
import 'package:demoappprovider/check/TimeChat.dart';
import 'package:flutter/material.dart';
import 'package:demoappprovider/model/person.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
//   runApp(MaterialApp(home: Homechatscreen()));
// }

class NaviagationDrawer extends StatefulWidget {
  String uid;
  NaviagationDrawer({super.key, required this.uid});

  @override
  State<NaviagationDrawer> createState() => _NaviagationDrawerState();
}

UserClient? user;

class _NaviagationDrawerState extends State<NaviagationDrawer> {
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    user = await AuthService().getUserData(widget.uid);
    setState(() {
      print(user!.urlImage);
    }); // Gọi để rebuild lại UI khi đã có dữ liệu
  }

  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [buildHealer(context), buildMenuItems(context)],
      ),
    ),
  );

  Widget buildHealer(BuildContext context) => Container(
    child: Column(
      children: [
        if (user == null)
          CircularProgressIndicator()
        else ...[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: 
            ClipOval(
              child: Image.network(
                user!.urlImage,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(  
                    Icons.person_outlined,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ),
          Text(user!.name),
          Text(user!.email),
        ],
      ],
    ),
  );
  Widget buildMenuItems(BuildContext context) => Column(
    children: [
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: Text("trang chủ"),
        onTap: () {},
      ),
      const Divider(color: Colors.black54),
    ],
  );
}

class Homechatscreen extends StatefulWidget {
  String uid;
  Homechatscreen({super.key, required this.uid});

  @override
  State<Homechatscreen> createState() => _HomechatscreenState();
}

class _HomechatscreenState extends State<Homechatscreen> {
  List<UserClient> users = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthService().getAllUsers(users, widget.uid).then((_) {
      setState(() {
        print(users);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uid != null) {
      return Scaffold(
        drawer: NaviagationDrawer(uid: widget.uid),
        appBar: AppBar(
          titleSpacing: 0,
          title: Text("HoanChatchit"),
          elevation: 0,
        ),
        body:
            users == null
                ? CircularProgressIndicator()
                : Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 4, right: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                users.map((item) {
                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        print(widget.uid);
                                        print(item.urlImage);
                                        print(item.name + "ịijiji");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => InterfaceChat(
                                                  userA: widget.uid,
                                                  userB: item.uid,
                                                  name: item.name,
                                                  url: item.urlImage,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Column(
                                          children: [
                                            ClipOval(
                                              child: Image.network(
                                                item.urlImage,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Icon(
                                                    Icons.person_outlined,
                                                    size: 50,
                                                    color: Colors.grey,
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            SizedBox(
                                              width: 50,
                                              child: Text(
                                                item.name, // Bạn có thể thay bằng tên từ list hoặc chỉ số
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),

                        Column(
                          children:
                              users.map((item) {
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    focusColor: Colors.amber,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => InterfaceChat(
                                                userA: widget.uid,
                                                userB: item.uid,
                                                name: item.name,
                                                url: item.urlImage,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 8,
                                        right: 8,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipOval(
                                            child: Image.network(
                                              item.urlImage,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Icon(
                                                  Icons.person_outlined,
                                                  size: 50,
                                                  color: Colors.grey,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                ),
                                                child: Text(
                                                  item.name, // Bạn có thể thay bằng tên từ list hoặc chỉ số
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              FutureBuilder<Object?>(
                                                future: MessagerFirestore()
                                                    .getLastMessage(
                                                      widget.uid,
                                                      item.uid,
                                                    ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Text(
                                                      "Đang tải...",
                                                    ); // Hoặc SizedBox.shrink() nếu không muốn gì cả
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text("Lỗi");
                                                  } else if (snapshot.hasData &&
                                                      snapshot.data != null) {
                                                    final lastMsg =
                                                        snapshot.data
                                                            as QueryDocumentSnapshot;
                                                    final data =
                                                        lastMsg.data()
                                                            as Map<
                                                              String,
                                                              dynamic
                                                            >;
                                                    final text =
                                                        data['text'] ??
                                                        "Chưa có tin nhắn";
                                                        
                                                    final timestamp = data['timestamp'] as Timestamp;
                                                    if(data['senderId']==widget.uid)
                                                    {
                                                      return Row(
                                                      children: [
                                                        Text(
                                                          "Bạn: $text",
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                                  
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 13
                                                          ),
                                                        ),
                                                        Text(Timechat().formatFriendlyTime(timestamp.toDate())),
                                                      ],
                                                    );
                                                    }
                                                    else{
                                                      return Row(
                                                      children: [
                                                        Text(
                                                          "$text",
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                        Text(Timechat().formatFriendlyTime(timestamp.toDate()),style: TextStyle(fontSize: 13),),
                                                      ],
                                                    );
                                                    }
                                                    
                                                  } else {
                                                    return Text(
                                                      "Chưa có tin nhắn",
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
