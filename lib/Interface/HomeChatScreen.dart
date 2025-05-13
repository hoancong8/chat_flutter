import 'package:demoappprovider/FirebaseService/AuthService.dart';
import 'package:demoappprovider/FirebaseService/Cloud_Firestore.dart';
import 'package:demoappprovider/Interface/InterfaceChat.dart';
import 'package:demoappprovider/FirebaseService/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:demoappprovider/model/person.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
//   runApp(MaterialApp(home: Homechatscreen()));
// }

List<String> _list = [
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
  'assets/hoan.png',
];

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
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: ClipOval(
              child: Image.network(
                user!.urlImage,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
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
    AuthService().getAllUsers(users).then((_) {
      setState(() {
        print(users);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NaviagationDrawer(uid: widget.uid),
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  users.map((item) {
                    return InkWell(
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.network(
                                item.urlImage,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              item.name, // Bạn có thể thay bằng tên từ list hoặc chỉ số
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          Column(
            children:
                users.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            _list[1],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          children: [
                            Text(
                              item.name, // Bạn có thể thay bằng tên từ list hoặc chỉ số
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
